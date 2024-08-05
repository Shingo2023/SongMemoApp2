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
        
        // カスタムツールバーをキーボードに追加
        addCustomToolbarToKeyboard()
    }
    //アドカスタムツールバートゥキーボード
    func addCustomToolbarToKeyboard() {
        // UIToolbarのインスタンスを作成
        let toolbar = UIToolbar()
        // コンテンツに合わせてツールバーのサイズを調整
        toolbar.sizeToFit()
        
        // "Done"ボタンを作成
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        // ボタンの間にスペースを作るためのフレキシブルスペースを作成
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // ツールバーにボタンを追加
        toolbar.items = [spacer, doneButton]
        
        // 各テキストフィールドにツールバーを設定
        actionNameField1.inputAccessoryView = toolbar
        actionMarkField1.inputAccessoryView = toolbar
        actionNameField2.inputAccessoryView = toolbar
        actionMarkField2.inputAccessoryView = toolbar
    }
    
    // "Done"ボタンが押されたときの処理
        @objc func doneButtonTapped() {
            // キーボードを閉じる
            self.view.endEditing(true)
        }
    
    // UINavigationControllerDelegate メソッド
    //    //新しいビューコントローラがナビゲーションスタックに表示される直前に呼び出されます。
    //    //navigationController: このデリゲートメソッドを呼び出している
    //    //UINavigationController のインスタンス。
    //    //viewController: ナビゲーションコントローラによって表示されようとしているビューコントローラ。
    //    // animated: アニメーションが使用されるかどうかを示すブール値。
    // UINavigationControllerDelegate メソッド
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //viewControllerではない時にtureを出す条件式 つまり他のページに遷移したときに保存処理が実行される
        //selfはActionEditViewControllerのインスタンス化
        // 他のページに遷移したときに保存処理を実行
        if viewController != self {
            saveActions()
        }
    }
    
    // アクションを保存するメソッド
    func saveActions() {
        // 各テキストフィールドからデータを取得し、ActionModelインスタンスを作成
        let action1 = ActionModel(id: UUID().uuidString, startIndex: 0, name: actionNameField1.text ?? "", mark: actionMarkField1.text ?? "")
        let action2 = ActionModel(id: UUID().uuidString, startIndex: 0, name: actionNameField2.text ?? "", mark: actionMarkField2.text ?? "")
        
        // ここで作成したアクションを保存する処理を行う
        // 例えば、モデルの配列に追加する、データベースに保存するなど
    }
}
