//
//  LyricsViewController.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/07/22.
//

import Foundation
import UIKit
import RealmSwift

class LyricsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var lyricsTextView: UITextView!
    //songTextModel: これは変数の名前です。SongTextModel 型のインスタンスを格納するために使用されます。
    //　!　→ implicitly unwrapped optional :インプリシットリーアンラップトオプショナル(暗黙的にアンラップされたオプショナル) これを使用すると、通常のオプショナルのように値があるかどうかを確認せずに、直接値にアクセスできます。
    //つまり、この変数はnilでないと仮定され、直接値として扱うことができますが、もしnilの場合、実行時エラーが発生します。
    var songTextModel: SongTextModel!
    // テキストビューがロックされているかどうかを示すフラグ
    var isLocked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // songTextModelがnilか確認
        //これは「オプショナルバインディング」と呼ばれる構文(if let 文とも呼ばれる)で、songTextModel が nil でない場合に、その値を使って処理を行います。
        //songTextModel が nil でない場合、その値が新しい定数 songTextModel にバインドされ、この定数を使ってif ブロック内の処理が行われます。
        //もし songTextModel が nil であれば、else ブロックの処理が行われます。
        if let songTextModel = songTextModel {
            // テキストビューの更新
            updateLyricsTextView()
            //もし songTextModel が nil だった場合、else ブロックの処理が実行されます。
        } else {
            print("songTextModelがセットされていません。")
            
            //lyricsTextViewのデリゲートとしてこのビューコントローラを設定
            lyricsTextView.delegate = self
            //アドカスタムボタンズトゥキーボード
            //キーボードにカスタムボタンを追加するカスタムメソッドを呼び出す
            addCustomButtonsToKeyboard()
            //Lockボタンをプログラム的に追加
            setupLockButton()
        }
    }
    //アップデートリリックテキストビュー
    func updateLyricsTextView() {
        //guard let文　関数内で特定の条件を満たせなかった場合にその時点で関数を実行せずに終了するもの。
        //モデルがモデルであった時
        //else nilの時実行される
        guard let songTextModel = songTextModel else {
            //return 文が実行され、関数 updateLyricsTextView() は何もせずに終了します。
            return
        }
        //lyricsTextView の text プロパティに、songTextModel.text の内容を設定します。これにより、lyricsTextView に歌詞のテキストが表示されます。
        lyricsTextView.text = songTextModel.text
        
        //attributedText:属性文字列
        //NSMutableAttributedString: テキストに属性（例えば色やフォントサイズ）を追加できるクラスです。
        let attributedText = NSMutableAttributedString(string: songTextModel.text)
        
        //for-in 文は、Swift におけるループ処理の一種で、コレクション（配列や辞書など）やシーケンスの各要素に対して繰り返し処理を行うために使用します。これにより、コレクションの要素を一つ一つ取り出して操作することができます。
        //songTextModel.colorRange に含まれるすべての色範囲について、attributedText に色の属性を設定します。
        //colorRange: songTextModel.colorRange 配列の要素で、テキスト内の色付けする範囲と色を指定します。
        //addAttribute: 指定した範囲のテキストに色の属性を追加します。
        //UIColor(named: colorRange.color) ?? UIColor.black: colorRange.color で指定された名前の色を取得します。名前の色が存在しない場合はデフォルトで黒色（UIColor.black）を使用します。
        //NSRange: 属性を適用する範囲を指定します。location は開始位置、length は範囲の長さ
        for colorRange in songTextModel.colorRange {
            attributedText.addAttribute(.foregroundColor, value: UIColor(named: colorRange.color) ?? UIColor.black, range: NSRange(location: colorRange.startIndex, length: colorRange.endIndex - colorRange.startIndex))
        }
        //songTextModel.sizeRangeに含まれるsizeRangeオブジェクトの各サイズ範囲に対して、指定されたフォントサイズを設定するための処理
        //songTextModel.sizeRangeという配列やコレクションに含まれる各sizeRangeオブジェクトに対してループ処理を行っています。
        for sizeRange in songTextModel.sizeRange {
            //各sizeRangeのstartIndexとendIndexを使って、その範囲の長さを計算し、それが0より大きい場合はフォントサイズを20.0に、そうでない場合は14.0に設定します。
            //この条件により、範囲が存在する場合（長さが0より大きい場合）には大きめのフォントサイズを、範囲が存在しない場合（長さが0の場合）には小さめのフォントサイズを適用します。
            let fontSize: CGFloat = (sizeRange.endIndex - sizeRange.startIndex) > 0 ? 20.0 : 14.0
            //attributedTextに対して、フォントサイズ属性を追加しています。
            //NSRange(location: sizeRange.startIndex, length: sizeRange.endIndex - sizeRange.startIndex)を使って、sizeRangeのstartIndexからendIndexまでの範囲に対して、決定したフォントサイズを適用します。
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: sizeRange.startIndex, length: sizeRange.endIndex - sizeRange.startIndex))
        }
        
        lyricsTextView.attributedText = attributedText
        
        
        // 他のメソッドも必要に応じて songTextModel を Optional として扱うように修正します。
        
        // サイズの設定
        for sizeRange in songTextModel.sizeRange {
            //フォントサイズを決定する
            //sizeRange.endIndex - sizeRange.startIndexで範囲の長さを計算します。
            //計算した範囲の長さが0より大きければフォントサイズを20.0に設定し、それ以外の場合は14.0に設定します。
            let fontSize: CGFloat = (sizeRange.endIndex - sizeRange.startIndex) > 0 ? 20.0 : 14.0
            //指定した範囲にフォントサイズを設定する
            //.addAttribute: NSMutableAttributedStringのメソッドで、特定の属性を文字列の指定された範囲に追加します。
            //.font: 追加する属性のキーです。この場合、文字列のフォントを設定するための属性キーです。
            //value: UIFont.systemFont(ofSize: fontSize): 属性の値を指定します。この場合、システムフォントの指定されたサイズ（fontSize）を設定します。 UIFont.systemFont(ofSize: fontSize) 指定されたサイズのシステムフォントを生成します。
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range:
                                            NSRange(location: sizeRange.startIndex, length: sizeRange.endIndex - sizeRange.startIndex))
        }
        //設定した属性付きテキストをlyricsTextViewに反映する
        lyricsTextView.attributedText = attributedText
    }
    //ロックボタン
    func setupLockButton() {
        //plain プレイン 無地
        //selector : Objective-Cランタイムで呼び出すメソッド
        //#selector(lockButtonTapped)) lockButtonTappedをセレクターにした。
        let lockButton = UIBarButtonItem(title: "Lock", style: .plain, target: self, action: #selector(lockButtonTapped))
        //UInavigationBarを設置　rightBarButtonItemプロパティ　右にロックボタンを設置
        self.navigationItem.rightBarButtonItem = lockButton
        //アップデートロックタイトル(ロックボタンメソッド)
        updateLockButtonTitle(lockButton)
    }
    //ロックかアンロックするメソッド
    //UIBarButtonItem を引数として受け取ります。この引数は、関数内で button として参照されます。
    func updateLockButtonTitle(_ button: UIBarButtonItem) {
        //"Unlock" : "Lock": これは、button の title プロパティを更新する行です。タイトルは、isLocked というブール型プロパティの値によって決まります。
        button.title = isLocked ? "Unlock" : "Lock"
    }
    //Objective-Cランタイムで呼び出し
    //_ sender センダー　送信者: この引数は、ボタンがタップされたときにそのボタンを表す UIBarButtonItem のインスタンス
    @objc func lockButtonTapped(_ sender: UIBarButtonItem) {
        //プロパティ値を反転
        //isLocked が true なら false に、false なら true にします。
        isLocked = !isLocked
        //lyricsTextViewの isEditable(UITextViewの)プロパティを isLocked の反転値に設定します。
        //これにより、ロックされている場合はテキストビューが編集不可になり、ロックが解除されている場合は編集可能になります。
        //isEditable イズエディタブル　編集可能
        //isEditable(UITextViewの)プロパティ Bool型 trueの場合、テキストビューはユーザーによって編集可能です。false の場合、編集不可です。
        lyricsTextView.isEditable = !isLocked
        //updateLockButtonTitle(sender) は、updateLockButtonTitle メソッドを呼び出して、ボタンのタイトルを更新するコードです。
        updateLockButtonTitle(sender)
    }
    //アドカスタムボタントゥキーボード
    func addCustomButtonsToKeyboard() {
        
        //UIツールバーのインスタンス化
        let toolbar = UIToolbar()
        
        //sizeToFit は、UIKitのメソッドで、ビューのサイズをそのコンテンツに基づいて自動的に調整するために使用されます。具体的には、ビューがその内部コンテンツを完全に表示できるようにサイズを変更します。
        toolbar.sizeToFit()
        
        //カラーボタン
        let colorButton = UIBarButtonItem(title: "Color", style: .plain, target: self, action: #selector(changeTextColor))
        //アクションボタン
        //action:タップされたときに実行するメソッド
        let actionButton = UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(insertActionMark1))
        
        //閉じるボタン
        let deneButton = UIBarButtonItem(title: "Dene", style: .plain, target: self, action: #selector(insertDeneText))
        
        //スペーサー　ツールバーのボタン間にスペースを追加するためのフレキシブルなスペーサー（spacer）を作成します。これにより、ボタン間の余白が均等に広がります。
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //ツールバーにボタンを追加
        toolbar.items = [colorButton, spacer, actionButton, spacer, deneButton]
        //lyricsTextViewのinputAccessoryViewプロパティにツールバーを設定し、キーボードの上にツールバーが表示されるようにします。
        lyricsTextView.inputAccessoryView = toolbar
    }
    // "Dene"ボタンが押されたときの処理
    @objc func insertDeneText() {
        // 現在のカーソル位置に「Dene」というテキストを挿入
        if let selectedRange = lyricsTextView.selectedTextRange {
            lyricsTextView.replace(selectedRange, withText: "Dene")
        }
    }
    //色を変更するコードをここに記述
    @objc func changeTextColor() {
        //selected　セレクテッド　選択された
        //lyricsTextView の現在の選択範囲を取得します。selectedRange は、選択されているテキストの範囲（開始位置と長さ）を表します。
        let selectedRange = lyricsTextView.selectedRange
        //テキストが選択されているかどうかを確認します。選択範囲の長さが0より大きい場合にのみ、次の処理を行います。
        if selectedRange.length > 0 {
            //Storage ストレージ
            //addAttribute アドアトリビュート 文字列の属性（動詞）
            //foregroundColor 前景色
            //textStorage の addAttribute メソッドを使用して、選択範囲のテキストに赤色を適用します。ここでは、テキストの前景色（文字の色）を赤色に変更しています。
            lyricsTextView.textStorage.addAttribute(.foregroundColor, value: UIColor.red, range: selectedRange)
            // colorRangeModelに追加
            //id: songTextModel.colorRange.count + 1 によって、既存の colorRange 配列の要素数に1を加えた値が設定され、新しいIDが割り当てられます。
            //startIndex: selectedRange.location(ロケーション:位置) からハイライトの開始位置を指定しています。
            //endIndex: selectedRange.location + selectedRange.length によって、ハイライトの終了位置を設定しています。
            //color: ハイライトの色を"red"（赤色）に設定しています。
            let colorRange = ColorRangeModel()
            songTextModel.colorRange.append(colorRange)
        }
    }
    //アクションからnilを取り除くメソッド
    @objc func insertActionMark1() {
        
        //realmのアクションを受け取る
        let realm = try! Realm()
        
        //このインスタンスしたモデル使えてる？
        // savedActions　は　realmを返して抽出したSongTextModel(モデル名)
        let savedActions = realm.objects(SongTextModel.self)
        
        //SongTextModelはクラス名
        //ソングテキストモデルがnilかどうか
        //guard let オプショナル値が nil でないことを確認し、その後にアンラップされた値を使用できるようにする
        guard let songTextModel = songTextModel else {
            //else{nilだった時の処理}
            print("エラー: songTextModel が nil です。")
            return
        }
        //actions 配列が空でないことを確認して、空の場合に早期リターンしています。
        //guard文　条件が 満たされていない場合に早期に処理を抜けるために使います。
        //isEmpty イエス・エンプティ 空かどうかをチェックするプロパティです。
        //!songTextModel.actions.isEmpty 配列が空ではない
        guard !songTextModel.actions.isEmpty else {
            //配列が空
            print("エラー: actions 配列が空です。")
            return
        }
        //if let 安全にアンラップする構文　{ nilではない } else { nilの場合 }
        //archived アーカイブヴド　:保存された
        //first? 配列の最初の要素を取り出すことができます。要素がない場合は、nil を返します。
        if let archivedActionMark1 = songTextModel.actions.first?.mark {
            // 挿入処理
            // insertText(): このメソッドは、指定されたテキスト（引数として渡された文字列）を現在のカーソル位置に挿入します。テキストビューの内容を変更します。
            lyricsTextView.insertText(archivedActionMark1)
            print("アクションマーク1: \(archivedActionMark1)")
        } else {
            print("エラー: 最初のアクションに mark が設定されていません。")
        }
    }
}
