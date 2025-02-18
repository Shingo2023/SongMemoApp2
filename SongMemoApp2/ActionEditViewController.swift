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
        
        // カスタムバックボタンを設定
        let backButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // キーボード表示・非表示の通知を監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // テキストフィールドにデリゲートを設定
        actionNameField1.delegate = self
        actionNameField2.delegate = self
        actionMarkField1.delegate = self
        actionMarkField2.delegate = self
        
    }
    //このメソッドは、ビューが画面に表示される直前に呼び出されます。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadSavedActions() // 画面表示時にデータを読み込む
        loadSavedActions()
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
        //UITextField に関連付けられた入力補助ビューを設定するプロパティです。このプロパティを使用することで、キーボードの上に表示されるカスタムビューを指定できます。通常は、ボタンやツールバーを表示して、ユーザーがテキストフィールドに入力する際に便利な操作を提供するために使用されます。
        actionNameField1.inputAccessoryView = toolbar
        actionMarkField1.inputAccessoryView = toolbar
        actionNameField2.inputAccessoryView = toolbar
        actionMarkField2.inputAccessoryView = toolbar
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
    // アクション名フィールドの文字数を10文字に制限
    // shouldChangeCharactersIn シュッドチェンジキャラクターズイン UITextFieldDelegateプロトコルに定義されているメソッド テキストフィールドに文字が入力・削除される直前にその操作を制御できます。
    // replacementString リプレイスメントストリング　textField(_:shouldChangeCharactersIn:replacementString:) に渡されるパラメータの一つで、新しく入力された文字列を表します。このメソッドは、ユーザーがテキストフィールドに文字を入力する、または削除しようとするたびに呼ばれ、その際に入力や削除が許可されるかどうかを制御できます。
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // フィールドがアクション名の場合、10文字以内に制限
        // if let 文　textField.text が nil でない場合に text にその値が代入され、かつ条件も満たす場合に処理を実行することができます。
        // || どちらかが満たされている場合に処理を実行したいときに使います。
        if (textField == actionNameField1 || textField == actionNameField2),
           let text = textField.text,
           // text を Objective-C の NSString 型に変換し、ユーザーが入力した range の範囲に string を差し替えた新しい文字列を作ります。
           // replacingCharacters リプレイシングキャラクターズ 特定の位置の文字を新しい文字列に置き換えたいときに使用します。このメソッドは NSString 型で利用されるメソッドです
            // 新しい文字列の 文字数が10を超えるかを確認します。10を超える場合は、この条件が true になります。
            (text as NSString).replacingCharacters(in: range, with: string).count > 10 {
            return false
        }
        return true
    }
    // アクション名の文字数制限
    func validateActionNames1() -> Bool {
        // guard let：条件を満たさない場合に、必ず else ブロックで早期に処理を中断します。条件を満たす場合は、そのまま後の処理が続行されます。
        //  入力文字数を10文字までに設定
        guard let actionName1 = actionNameField1.text, actionName1.count <= 10 else {
            return false
        }
        return true
    }
    func validateActionNames2() -> Bool {
        guard let actionName2 = actionNameField2.text, actionName2.count <= 10 else {
            return false
        }
        return true
    }
    
    //validate -ヴァリデイト :検証
    func validateActionMarks1() -> Bool {
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
    //戻るボタを押した際に、アクションマークの検証を行い、条件を満たす場合はsaveAction()を実行。満たさない場合はUIAlertを表示して前の画面に戻る処理を行う」というもの。
    //このメソッド名はUINavigationControllerDelegate プロトコルの一部であり、Appleのフレームワークによって定義されています。そのため、このメソッドのシグネチャを変更することはできず、必ず正確にこの名前とパラメータを使用する必要があります。
    // navigationController(_:willShow:animated:) は　UINavigationControllerDelegate メソッド
    // navigationController: このデリゲートメソッドを呼び出している。
    // viewController: ナビゲーションコントローラによって表示されようとしているビューコントローラ。
    // animated: アニメーションが使用されるかどうかを示すブール値。
    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // if文　条件がtureの場合に括弧内を実行
        // viewController　UIViewControllerクラスのインスタンス、つまり現在表示されているビューコントローラ
        // !否定論
        // self self は、現在のインスタンス自身を指すものです。クラスや構造体の内部で、そのインスタンス（オブジェクト）自身にアクセスする際に使用します
        // つまり、viewcontrollerのデリデートが働いた(アクションがviewに入力された)ときに以下が実行される
        if viewController != self {
            //!:論理否定　ヴァリデイト（:検証）アクションマーク
            //if validateActionMarks() && validateActionMarks2() seveActionを呼びだす仕様にする前のコード
            if validateActionMarks1() && validateActionMarks2() {
                saveAction()// 検証が成功したらsaveAction()を呼び出して保存
            } else {
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
        // if文　条件がtureの場合に括弧内を実行 安全に実行
        // 関数バリデイトアクションマーク && 関数バリデイトアクションマーク2
        if validateActionNames1() && validateActionMarks1() && validateActionNames2() && validateActionMarks2(){
            //ローカル定数action1 = ActionModel() :アクションモデルクラスのインスタンスオブジェクト　上記の名前とマークを一体でActionModelに保存
            let action1 = ActionModel()
            let action2 = ActionModel()
            //上記にモデルを書いたのでイニシャライザーを定義
            action1.name = actionNameField1.text ?? ""
            action1.mark = actionMarkField1.text ?? ""
            action2.name = actionNameField2.text ?? ""
            action2.mark = actionMarkField2.text ?? ""
            //レルムのインスタンス化
            let realm = try! Realm()
            //レルムに書き込み
            try! realm.write {
                //上記で定義したローカル定数をレルムに書き込み
                realm.add(action1)
                realm.add(action2)
            }
            //ActionModel のみを保存すると、どの曲（または歌詞）に関連付けられているかがわかりません。
            //SongTextModel の actions プロパティにアクションを追加することで、曲に関連付けられたアクションを管理します。
            // SongTextModel（クラス？） のインスタンスを取得
            var songTextModel: SongTextModel
            //if let 安全にアンラップする構文 { nilではない } else { nilの場合 } :オプショナル型から値を安全に取り出すために使用される構文です。
            //existing エグジスティング：「存在している」「既存の」という意味。
            if let existngSongTextModel = realm.objects(SongTextModel.self).first {
                songTextModel = existngSongTextModel
            } else {
                // nilの場合　つまり、SongTextModel が存在しない場合に新しく作成して保存
                songTextModel = SongTextModel()
                try! realm.write {
                    realm.add(songTextModel)
                }
            }
            try! realm.write {
                songTextModel.actions.append(action1)
                songTextModel.actions.append(action2)
            }
            //上記の処理ができたときにprintして確認している
            print("保存されたアクション: mark1: \(action1.mark), name1: \(action1.name), mark2: \(action2.mark), name2: \(action2.name)")
        }
    }
    //SavedActionsの呼び出し。保存したアクションデータをviewWillAppearで呼び出している。
    func loadSavedActions() {
        //realmから呼び出し
        let realm = try! Realm()
        //realm.objects(SongTextModel)ファーストを呼び出し
        if let existingSongTextModel = realm.objects(SongTextModel.self).first {
            //if文　条件式(実行されるコード)
            //保存されたアクションが１つあれば
            if existingSongTextModel.actions.count > 0 {
                //１つ目アクション
                let action1 = existingSongTextModel.actions[0]
                //その中身
                actionNameField1.text = action1.name
                actionMarkField1.text = action1.mark
            }
            if existingSongTextModel.actions.count > 1 {
                let action2 = existingSongTextModel.actions[1]
                actionNameField2.text = action2.name
                actionMarkField2.text = action2.mark
            }
        }
    }
    // カスタムバックボタンが押された時の処理
    @objc func backButtonTapped() {
        if validateActionMarks1() && validateActionMarks2() {
            saveAction()
        } else {
            // バリデーションに失敗した場合に通知を送信
            NotificationCenter.default.post(name: NSNotification.Name("ValidationErrorNotification"), object: nil)
        }
        // エラーがあってもホーム画面に戻る
        navigationController?.popViewController(animated: true)
    }
    // "Done"ボタンが押されたときの処理
    @objc func doneButtonTapped() {
        // キーボードを閉じる
        self.view.endEditing(true)
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
