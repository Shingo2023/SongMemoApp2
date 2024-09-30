//
//  ActionEditViewController.swift - オリジナルアクション編集画面 -
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//

import Foundation
import UIKit
import RealmSwift

class ActionEditViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
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
        
        actionMarkField1.delegate = self
        actionMarkField2.delegate = self
    }
    //アドカスタムツールバートゥキーボード
    func addCustomToolbarToKeyboard() {
        //ツールバーの位置
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        // "Done"ボタンを作成
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        // ボタンの間にスペースを作るためのフレキシブルスペースを作成　spacer:スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
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
    //    //navigationController: このデリゲートメソッドを呼び出している。
    //    //UINavigationController のインスタンス。
    //    //viewController: ナビゲーションコントローラによって表示されようとしているビューコントローラ。
    //    // animated: アニメーションが使用されるかどうかを示すブール値。
    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != self {
            // guard let がnilであればelseが実行される
            //1文字ならnilではない
            guard let actionMark1 = actionMarkField1.text, actionMark1.count == 1,
                  let actionMark2 = actionMarkField2.text, actionMark2.count == 1 else {
                // nilの時に実行されるエラーメッセージ
                let alert = UIAlertController(title: "エラー", message: "アクションマークは1文字の絵文字である必要があります。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                navigationController.popViewController(animated: false) // 戻るのをキャンセル
                return
            }
            saveActions()
        }
    }
    
    //　アクションを保存するメソッド
    func saveActions() {
        guard let actionMark1 = actionMarkField1.text, actionMark1.count == 1,
              let actionMark2 = actionMarkField2.text, actionMark2.count == 1 else {
            print("アクションマークが無効です。")
            return
        }
        
        let action1 = ActionModel()
        let action2 = ActionModel()
        action1.mark = actionMark1
        action2.mark = actionMark2
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(action1)
            realm.add(action2)
        }
        
        print("保存されたアクション: mark1: \(action1.mark), mark2: \(action2.mark)")
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
           saveActions()
       }
}

//キーボードに閉じるボタンがない。マーク２のテキストフィールドはキーボードが出ると、キーボードに隠れてしまう時どうすればいいですか？なお、フィールドの位置は変えたくありません
//保存されたアクションをコンソール出力されたい。
