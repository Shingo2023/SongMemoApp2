//  リリックス
//  LyricsEditViewController.swift -歌詞編集画面-
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//
import UIKit

class LyricsViewController: UIViewController {
    
    var SongTextModel: SongTextModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ベースビューの設定 バックグランドカラー　ホワイト
        view.backgroundColor = .white
        
        // 歌詞の配列
        // songTextModel?.text:　songTextModelが存在する場合に、そのtextプロパティを取得します。 songTextModelがnilの場合は、この部分全体がnilになります。
        //.components(separatedBy: "\n"): textが存在する場合、それを改行 ("\n") で分割して文字列の配列にします。
        //?? []: songTextModel?.text.components(separatedBy: "\n")の結果がnilの場合、空の配列 ([]) を代わりに使用します。
        let lyrics = songTextModel?.text.components(separatedBy: "\n") ?? []
        
        // アクションの読み込み
        //ユーザーデフォルツ　ユーザーの保存設定
        //ユーザーデフォルツクラスの　standard プロパティ
        let userDefaults = UserDefaults.standard
        //guard let これ以上処理を進めたくない場合に使用します。 nilが入っていたらエラーとして扱うケースだった場合などによく使う。
        //.data(forKey: "savedActions"), キーsavedActionsに関連付けられたデータを取得している。
        guard let decodedData = userDefaults.data(forKey: "savedActions"),
              //try?は、NSKeyedUnarchiver.unarchiveTopLevelObjectWithDataがエラーを投げる可能性があるため、それをオプショナルで扱う構文です。エラーが発生した場合はnilを返す。
              //NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData)は、decodedDataを使ってオブジェクトをデコードしようとしている。
              //as?
              //as? [ActionModel]は、デコードされたオブジェクト（保存されていたデータを元の状態に戻した結果のオブジェクトを指します。）を　   　[ActionModel]型にキャストしようとします。このキャストが失敗した場合はnilを返す。
              //else { return }は、もしデコードやキャストが失敗した場合、現在のスコープ（通常は関数やメソッド）から抜けることを意味する。
                
             // let savedActions = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as? [ActionModel] else {
                let savedActions = try? NSKeyedUnarchiver.unarchivedObject(ofClass:from:)as? [ActionModel] else {
            return
        }
        
        // 歌詞とアクションを配置するためのスタートY位置
        var yOffset: CGFloat = 100
            

        //歌詞を1行ずつ表示し、その下に絵文字を追加
        //for-in文 条件の全てのパターンを順番に処理する構文
        //enumerated エニュメレイテッド 配列などのコレクションの要素とそのインデックスをペアにして列挙するメソッドです。
        //lyrics配列の各要素とそのインデックスを繰り返します。
        //indexには配列内の位置（インデックス）が、lineには各要素（歌詞の一行）が入ります。
        for (index, line) in lyrics.enumerated() {
            
            //UIラベルのインスタンス化
            let label = UILabel()
            //テキスとプロパティにラインを追加
            label.text = line
            // numberOfLines（プロパティ） = 0　ラベルの行数を無制限に設定（テキストが複数行になる場合に対応）
            label.numberOfLines = 0
            //フレームの位置
            label.frame = CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 30)
            //addSubview(label)は、viewに対してlabelをサブビューとして追加します。これにより、labelがviewの中に表示される
            view.addSubview(label)
            
            // 次のY位置の更新
            yOffset += 40++
            
            //対応するアクションマークを表示
            //indexがsavedActions.countよりも小さい場合にtrueを返す
            if index < savedActions.count {
                //UIlabelを定数emojiLabelとしてインスタンス化
                let emojiLabel = UILabel()
                //emojiLabelのtextプロパティ　savedActions配列のindex番目の要素のmarkプロパティの値
                emojiLabel.text = savedActions[index].mark
                //emojiLabelのフォントプロパティ
                //UIFontは、フォントを扱うクラス
                //systemFont(ofSize: 30)　指定したサイズ（30ポイント）のシステムフォントを作成して返す
                emojiLabel.font = UIFont.systemFont(ofSize: 30)
                //テキストアラインメント　センター　emojiLabelのテキストを中央揃えに設定
                emojiLabel.textAlignment = .center
                //絵文字ラベルフレーム x座標は20 y座標はオフセット（標準点からの距離）　ワイドviewフレーム　ワイド−40(左右20ずつ削る)　高さ30
                emojiLabel.frame = CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 30)
                //addSubview(emojiLabel)は、viewに対してemojiLabelをサブビューとして追加します。これにより、emojiLabelがviewの中に表示される
                view.addSubview(emojiLabel)
            }
            
            // 次のY位置の更新
            yOffset += 50
        }
    }
}
