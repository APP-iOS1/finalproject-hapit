import Foundation
import NotificationCenter

// UNUserNotificationCenterDelegate = foreground에도 푸시가 보이도록
// NSObject를 가져와야 UNUserNotificationCenterDelegate 부를 수 있다
@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    //허가 받았는 지 나타내는 bool값 publish
    @Published var isGranted = false
    //노티 어펜드할 어레이
    @Published var pendingRequests: [UNNotificationRequest] = []

    //MARK: - UNUserNotificationCenterDelegate의 함수구현
    // 1. Delegate 클래스에게 이 클래스가 functions를 다루기위한 델리깃이라는걸 알려주기위한 초기화
    override init() { //5. 오버라이드 추가해줌
        // 4. 그래서 슈퍼 이닛을 넣어주고
        super.init()
        // 2. 그래서 다음에 이걸 추가 -> 노티센터 델리깃은 얘 스스로임. 이라고
        // 3. 근데 이거하러면 이니셜라이저가 오버라이드 이니셜라이저가 되야한대
        notificationCenter.delegate = self
    }
    
    // 6. 이제 우린 Delegate function을 만들어줄 수 있게 됐어
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        //델리깃 func는 노티가 post될 때마다 불림 그래서 여기도 pedingRequest해야함
        await getPendingRequests()
        return [.sound, .banner]
        //이게 이제 foreGround에서 나타나는 사운드와 배너
    }

    // MARK: - 사용자 기기 내 알림 허용을 요청(badge는 사용하지 않는다)
    func requestAuthorization() async throws {
        try await notificationCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    // MARK: - 현재 아이폰 settings의 앱 푸시 허가 여부 불러오기
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
        //보라색 경고: Publishing changes from background is not allowed.
        //=> 백그라운드 쓰레드에서 값 변화를 publish 하는건 허용되지 않음 그래서 @MainActor붙임
    }
    
    // MARK: - (아이폰 설정 앱 알림 허용이 꺼져있을 때) settings 창을 열어주는 함수
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // MARK: - 펜딩 리퀘스트(보류중인 노티 어레이) 업데이트해주는 함수
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    // MARK: - 노티피케이션 대기열에 넣어주는 함수
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default
        let dateComponents = localNotification.dateComponents
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
        try? await notificationCenter.add(request)
        
        await getPendingRequests()
    }
    
    // MARK: 생성된 알림을 모두 지우는 함수
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
        print("Pending: (pendingRequests.count)")
    }
}
