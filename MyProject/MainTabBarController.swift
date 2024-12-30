
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activitiesVC = UINavigationController(rootViewController: ActivitiesViewController())
        activitiesVC.tabBarItem = UITabBarItem(title: "Активности", image: UIImage(systemName: "figure.walk"), selectedImage: UIImage(systemName: "figure.walk.circle.fill"))
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [activitiesVC, profileVC]
        
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ActivityInProgressViewController {
            vc.hidesBottomBarWhenPushed = true
        }
    }
}
