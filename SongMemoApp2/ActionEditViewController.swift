//
//  ActionEditViewController.swift - オリジナルアクション編集画面 -
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation
import UIKit

class ActionEditViewController: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var actionNameField1: UITextField!
    @IBOutlet weak var actionMarkField1: UITextField!
    @IBOutlet weak var actionNameField2: UITextField!
    @IBOutlet weak var actionMarkField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationController のデリゲートを設定
        self.navigationController?.delegate = self
    }
    
    // UINavigationControllerDelegate メソッド
    //新しいビューコントローラがナビゲーションスタックに表示される直前に呼び出されます。
    //navigationController: このデリゲートメソッドを呼び出している
    //UINavigationController のインスタンス。
    //viewController: ナビゲーションコントローラによって表示されようとしているビューコントローラ。
    // animated: アニメーションが使用されるかどうかを示すブール値。
    func navigationController(_ navigationController: UINavigationController,willShow viewController: UIViewController, animated: Bool) {
        //viewControllerではない時にtureを出す条件式 つまり他のページに遷移したときに保存処理が実行される
        //selfはActionEditViewControllerのインスタンス化
        if viewController != self {
            //関数の呼び出し
            saveActions()
            
            //アクションを保存するメソッド
            func saveActions() {
                // 各テキストフィールドからデータを取得し、ActionModelインスタンスを作成する
                _ = ActionModel(id: UUID().uuidString, startIndex: 0, name: actionNameField1.text ?? "", mark: actionMarkField1.text ?? "")
                _ = ActionModel(id: UUID().uuidString, startIndex: 0, name: actionNameField2.text ?? "", mark: actionMarkField2.text ?? "")
                
//                プリントする時に使用
//                // 保存処理のコードをここに記述
//                print("Action1: \(action1), Action2: \(action2)")
            }
        }
        
    }
}
