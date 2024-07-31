//
//  LyricsViewController.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/07/22.
//

import Foundation
import UIKit

class LyricsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var lyricsTextView: UITextView!
        //　!　→ implicitly unwrapped optional :インプリシットリーアンラップトオプショナル(暗黙的にアンラップされたオプショナル) これを使用すると、通常のオプショナルのように値があるかどうかを確認せずに、直接値にアクセスできます。
        var songTextModel: SongTextModel!
        // テキストビューがロックされているかどうかを示すフラグ
        var isLocked: Bool = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //lyricsTextViewのデリゲートとしてこのビューコントローラを設定
            lyricsTextView.delegate = self
            
            //歌詞テキストビューを更新するカスタムメソッドを呼び出す
            updateLyricsTextView()
            
            //アドカスタムボタンズトゥキーボード
            //キーボードにカスタムボタンを追加するカスタムメソッドを呼び出す
            addCustomButtonsToKeyboard()
            
            //Lockボタンをプログラム的に追加
            setupLockButton()
        }
        
        func updateLyricsTextView() {
            // 歌詞テキストを設定
            lyricsTextView.text = songTextModel.text
            
            // 色とサイズの設定
            //NSMutableAttributedString（エヌエスミュータブルアトリビューテッドストリング）を使用して、文字列の属性（色やフォントなど）を設定できるようにします。ここでは、歌詞テキストを基にattributedTextを作成しています。
            let attributedText = NSMutableAttributedString(string: songTextModel.text)
            
            // 色の設定
            //for-in文、コレクション（配列や辞書など）の各要素に対して繰り返し処理を行うために使用される
            for colorRange in songTextModel.colorRange {
                //attributed アトリビューテッド :文字列に対しての属性（色、フォント、スタイル）が設定された状態（形容詞）
                //addAttribute アドアトリビュート　:文字列に対しての属性（色、フォント、スタイル）を追加する操作（動詞）
                //foregroundColor　前景色（テキスト色）
                //value: UIColor(named: colorRange.color) ?? （上記意味右に続く）UIColor.black,　colorRange.colorに対応する名前の色を取得します。もし取得できない場合はデフォルトで黒色（UIColor.black）を使用します。
                //range: NSRange(location: colorRange.startIndex, length: colorRange.endIndex - colorRange.startIndex))（上記意味右に続く）colorRangeに定義された範囲（開始インデックスから終了インデックスまで）に対して属性を設定します。
                attributedText.addAttribute(.foregroundColor, value: UIColor(named: colorRange.color) ?? UIColor.black, range: NSRange(location: colorRange.startIndex, length: colorRange.endIndex - colorRange.startIndex))
            }
            
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
            let actionButton = UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(insertActionMark))
            //スペーサー　ツールバーのボタン間にスペースを追加するためのフレキシブルなスペーサー（spacer）を作成します。これにより、ボタン間の余白が均等に広がります。
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //ツールバーに「Color」ボタン、スペーサー、「Action」ボタンを順に追加します。
            toolbar.items = [colorButton, spacer, actionButton]
            //lyricsTextViewのinputAccessoryViewプロパティにツールバーを設定し、キーボードの上にツールバーが表示されるようにします。
            lyricsTextView.inputAccessoryView = toolbar
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
                let colorRange = ColorRangeModel(id: songTextModel.colorRange.count + 1, startIndex: selectedRange.location, endIndex: selectedRange.location + selectedRange.length, color: "red")
                songTextModel.colorRange.append(colorRange)
            }
        }
        //インサートアクションマーク
        @objc func insertActionMark() {
            // アクションマークを挿入するコードをここに記述
            //アラート　セレクト　メッセージ　プリファードスタイル　アクションシート
            //UIAlertControllerでは、preferredStyleには以下の2つのスタイルがあります：                                           .alert: 画面の中央に表示される標準的なアラートスタイル。 .actionSheet: 画面の下からスライドしてくるアクションシートスタイル。
            let alert = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)
            
            //songTextModel.actions配列内の各要素actionに対してループを回します。この配列は、アクションマークやその関連情報を含むモデルのコレクション
            for action in songTextModel.actions {
                //UIAlertActionオブジェクトを生成しています。UIAlertActionはアラートコントローラで選択可能なアクションを表します。
                let actionItem = UIAlertAction(title: action.mark, style: .default) { _ in
                    //lyricsTextViewというテキストビューの選択範囲を取得し、selectedRangeという変数に格納しています。self.lyricsTextViewは、このメソッドが属するクラスのインスタンスのプロパティを指しています。
                    let selectedRange = self.lyricsTextView.selectedRange
                    //replaceCharacters　リプレースキャラクターズ:文字を置き換える
                    //lyricsTextViewのtextStorageを操作して、selectedRangeで指定された範囲の文字列をaction.markに置き換えています。
                    self.lyricsTextView.textStorage.replaceCharacters(in: selectedRange, with: action.mark)
                    //アクションポジション　＝　アクションポジションモデル
                    _ = ActionPositionModel(id: UUID().uuidString, startIndex: selectedRange.location, action: action)
                    // actionPositionModelに追加
                    //songTextModelオブジェクトのactions配列に、現在選択されたactionを追加します。これにより、このアクションがアプリケーション内で記録され、後でアクセスできるようになります。
                    self.songTextModel.actions.append(action)
                }
                //前に作成したactionItem（UIAlertActionオブジェクト）をアラートコントローラに追加します。これにより、アクションシートにこの選択肢が表示され、ユーザーがそれを選択できるようになります。
                alert.addAction(actionItem)
            }
            //UIAlertActionオブジェクトを作成し、アラートに追加します。
            //title: "Cancel"は、アラートに表示されるボタンのタイトルを「Cancel」に設定します。
            //style: .cancelは、ボタンのスタイルをキャンセル用に指定します。これにより、ボタンはキャンセルアクションとして機能します。
            //handler: nilは、キャンセルボタンが押されたときに特に何も処理を行わないことを示します。
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            //presentメソッドを使って、alert（UIAlertControllerオブジェクト）を画面に表示します。
            //completion　コンプリーション　:完了 nilは、アラートが表示された後に特定の処理を行わないことを意味します。
            present(alert, animated: true, completion: nil)
        }
        //テクストビューディドゥチェンジ
        func textViewDidChange(_ textView: UITextView) {
            songTextModel.text = textView.text
        }
    }
