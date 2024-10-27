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
        // アドカスタムツールバートゥキーボードの呼び出し　テキストフィールドが押された時に出てくる
        addCustomToolbarToKeyboard()
        
        // キーボード表示・非表示の通知を監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        actionMarkField1.delegate = self
        actionMarkField2.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedActios() // 画面表示時にデータを読み込む
        
    }

    //アドカスタムツールバートゥキーボード
    func addCustomToolbarToKeyboard() {
        //ツールバーの設置と位置
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        // "Done"ボタンを作成
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        // ボタンの間にスペースを作るためのフレキシブルスペースを作成　spacer:スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //　setItemsメソッドでツールバーに配置
        toolbar.setItems([spacer, doneButton], animated: true)
        
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
    
    // キーボードが表示されたときに呼び出されるメソッド
    //Notification -ノウティフィケイション :通知
    // if文　条件がtureの場合に括弧内を実行
    //FirstResponder -ファーストレスポンダー :ユーザーからの入力イベント（例：タッチ、キーボード入力など）を最初に受け取るオブジェクトのこと
    //return リターンされてこの処理を終了する
    @objc func keyboardWillShow(_ notification: Notification) {
        // キーボードのサイズを取得
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            // 現在フォーカスしているテキストフィールドがどれかを確認
            if let activeField = self.view.findFirstResponder() as? UITextField {
                // 現在フォーカスしているテキストフィールドがキーボードに隠れるかを確認
                if self.view.frame.origin.y == 0 {
                    let distanceToBottom = self.view.frame.size.height - (activeField.frame.origin.y + activeField.frame.size.height)
                    let offset = keyboardHeight - distanceToBottom
                    if offset > 0 {
                        // キーボードの高さ分だけビューを上に移動
                        UIView.animate(withDuration: 0.3) {
                            self.view.frame.origin.y = -offset
                        }
                    }
                }
            }
        }
    }
    // キーボードが非表示になったときに呼び出されるメソッド
    //notification には、キーボードが隠れる際の情報が含まれます。
    @objc func keyboardWillHide(_ notification: Notification) {
        //現在のビュー（画面）の位置を示すY座標です。
        if self.view.frame.origin.y != 0 {
            //UIView.animate は、ビューの位置やサイズをアニメーション付きで変更するためのメソッドです。
            //withDuration: 0.3 は、アニメーションの時間を指定しています。ここでは0.3秒でビューを元の位置に戻します。
            UIView.animate(withDuration: 0.3) {
                //これは、ビュー（self.view）のY座標を0に設定しています。
                self.view.frame.origin.y = 0
            }
        }
        // ビューを元の位置に戻す
        //これはアニメーションを行うメソッドです。withDuration: 0.3 はアニメーションの時間を0.3秒に設定しています。つまり、アニメーションが0.3秒かけて実行されます
        UIView.animate(withDuration: 0.3) {
            //self.view.frame.origin.y は、現在のビュー（self.view）の 垂直方向の位置（Y軸の位置）を示します。
            //-keyboardHeight は、キーボードの高さの分だけ画面を 上に移動 するという意味です。高さをマイナスにすることで、ビューの上部をキーボードが表示された分だけ上にずらします。
            self.view.frame.origin.y = 0
        }
    }
    
    //validate -ヴァリデイト :検証
    func validateActionMarks() -> Bool {
        
        
        // guard let：条件を満たさない場合に、必ず else ブロックで早期に処理を中断します。条件を満たす場合は、そのまま後の処理が続行されます。
        // actionMark1 が nil または 1文字でない場合に false を返す
        
        guard let actionMark1 = actionMarkField1.text, actionMark1.count == 1 else {
            return false
        }
        //条件を満たした場合に true を返します。
        return true
    }
    func validateActionMarks2() -> Bool {
        guard let actionMark2 = actionMarkField2.text, actionMark2.count == 1 else {
            return false
        }
        return true
    }
    // navigationController(_:willShow:animated:) は　UINavigationControllerDelegate メソッド
    // 新しいビューコントローラがナビゲーションスタックに表示される直前に呼び出されます。
    // navigationController: このデリゲートメソッドを呼び出している。
    // viewController: ナビゲーションコントローラによって表示されようとしているビューコントローラ。
    // animated: アニメーションが使用されるかどうかを示すブール値。
    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // if文　条件がtureの場合に括弧内を実行
        // viewController　UIViewControllerクラスのインスタンス、つまり現在表示されているビューコントローラ
        // !否定論
        // self self は、現在のインスタンス自身を指すものです。クラスや構造体の内部で、そのインスタンス（オブジェクト）自身にアクセスする際に使用します
        if viewController != self {
            //!:論理否定　ヴァリデイト（:検証）アクションマーク
            if !validateActionMarks() && !validateActionMarks2() {
                let alert = UIAlertController(title: "エラー", message: "アクションマークは1文字である必要があります。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //presentメソッド。アラートはアニメーションありで画面遷移する
                present(alert, animated: true)
                //現在のビューコントローラをナビゲーションスタックからポップし、前の画面に戻る処理を行います。false なので、画面遷移にアニメーションがない状態で戻ります。
                navigationController.popViewController(animated: false)
            }
        }
    }
    //アクション保存
    func saveAction() {
        // if文　条件がtureの場合に括弧内を実行
        // 関数バリデイトアクションマーク && 関数バリデイトアクションマーク2
        if validateActionMarks() && validateActionMarks2() {
            //ローカル定数action1 = ActionModel() :アクションモデルクラスのインスタンスオブジェクト
            let action1 = ActionModel()
            let action2 = ActionModel()
            //! 強制アンラップ
            //action1 というオブジェクトの mark プロパティに、actionMarkField1 というテキストフィールドの内容（text プロパティ）を代入しています。
            action1.mark = actionMarkField1.text!
            action2.mark = actionMarkField2.text!
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(action1)
                realm.add(action2)
            }
            print("保存されたアクション: mark1: \(action1.mark), mark2: \(action2.mark)")
            
        }
    }
    //アクションデータ読み込み
    func loadSavedActios() {
        let realm = try! Realm()
        let savedActions = realm.objects(ActionModel.self)
        
        if let firstAction = savedActions.first {
            actionMarkField1.text = firstAction.mark
        }
        if let lastAction = savedActions.last {
            actionMarkField2.text = lastAction.mark
        }
    }
    
    
}
extension UIView {
    //ファインド（:見つける）ファーストレスポンダー
    // ビュー階層の中でファーストレスポンダーを探すメソッド
    //この関数はUIViewオブジェクト（ファーストレスポンダー）を返します。ファーストレスポンダーが見つからなかった場合はnilを返します。
    func findFirstResponder() -> UIView? {
        // if文　条件がtureの場合に括弧内を実行
        //selfはこのメソッドを呼び出しているビュー
        //このビューがファーストレスポンダーであれば、trueを返します。もしこのビュー自体がファーストレスポンダーなら、そのビュー自身 (self) を返します。
        if self.isFirstResponder {
            return self
        }
        //self.subviews：このビュー (self) に追加されているすべてのサブビュー（子ビュー）の配列です。この部分では、各サブビューに対して再帰的にfindFirstResponder()を呼び出しています。
        //再帰的な検索：このループは、各サブビューについてfindFirstResponder()を実行します。もしサブビューの中にファーストレスポンダーが見つかれば、それを返します。
        for subview in self.subviews {
            //if let文 :nilかもしれない値を安全に取り出す構文
            if let firstResponder = subview.findFirstResponder() {
                //nilだったら安全にfirstResponderがリターンされる
                return firstResponder
            }
        }
        return nil
    }
}
