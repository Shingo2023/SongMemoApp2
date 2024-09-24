//
//  ActionEditViewController.swift - オリジナルアクション編集画面 -
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation
import UIKit
import RealmSwift

class ActionEditViewController: UIViewController,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var actionNameField1: UITextField!
    
    @IBOutlet weak var actionMarkField1: UITextField!
    
    @IBOutlet weak var actionNameField2: UITextField!
    //@IBOutlet weak var actionNameField2: UITextField!
    
    @IBOutlet weak var actionMarkField2: UITextField!
    //@IBOutlet weak var actionMarkField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationController のデリゲートを設定
        self.navigationController?.delegate = self
        
        // カスタムツールバーをキーボードに追加
        addCustomToolbarToKeyboard()
    }
    //アドカスタムツールバートゥキーボード
    func addCustomToolbarToKeyboard() {
        //ツールバーの位置
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
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
    
    //　アクションを保存するメソッド
    func saveActions() {
        // 各テキストフィールドからデータを取得し、ActionModelインスタンスを作成
        let action1 = ActionModel()
        let action2 = ActionModel()
        
        //テキストフィールドからデータを取得
        //if let オプショナル型の値を安全にアンラップするための構文
//        if let 定数名 = オプショナル値 {
//            // オプショナル値がnilでない場合に実行される処理
//        } else {
//            // オプショナル値がnilの場合に実行される処理（任意）
//        }
        //ローカル定数actionName1 = UItextFieldとテキストプロパティ　Fieldの文字数が１より少ない
        if let actionMark1 = actionMarkField1.text, actionMark1.count <= 1 {
            action1.mark = actionMark1
        } else {// 1文字より多い場合のエラー
            print("アクションマークは1文字の絵文字である必要があります。")
        }
        if let actionMark2 = actionMarkField2.text, actionMark2.count <= 1 {
            action2.mark = actionMark2
        } else {// 1文字より多い場合のエラー
            print("アクションマークは1文字の絵文字である必要があります。")
        }
        // Realmデータベースにアクションを保存
        //　realm上にこの書き込む宣言
        let realm = try! Realm()
        // writeメソッドを使って書き込みトランザクションを開始
        try! realm.write {
            //　ブジェクト（）をrealmデータベースに保存
            realm.add(action1)
            realm.add(action2)
        }

    }
}

