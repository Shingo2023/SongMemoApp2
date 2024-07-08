//  リリックス
//  LyricsEditViewController.swift -歌詞編集画面-
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/30.
//
import UIKit

class LyricsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 歌詞の配列
        let lyrics = [
            //歌詞の1行目
            "Line 1 of the lyrics",
            "Line 2 of the lyrics",
            "Line 3 of the lyrics",
            "Line 4 of the lyrics",
            "Line 5 of the lyrics",
            "Line 6 of the lyrics",
            "Line 7 of the lyrics",
            "Line 8 of the lyrics",
            "Line 9 of the lyrics",
            "Line 10 of the lyrics",
            "Line 11 of the lyrics",
            "Line 12 of the lyrics",
            "Line 13 of the lyrics",
            "Line 14 of the lyrics",
            "Line 15 of the lyrics",
            "Line 16 of the lyrics",
            "Line 17 of the lyrics",
            "Line 18 of the lyrics",
            "Line 19 of the lyrics",
            "Line 20 of the lyrics"
        ]
        
        // アクションの読み込み
        //ユーザーデフォルツ　ユーザーの保存設定　
        //ユーザーデフォルツクラス
        //standard プロパティ（クラス）
        let userDefaults = UserDefaults.standard
        //guard let これ以上処理を進めたくない場合に使用します。 nilが入っていたらエラーとして扱うケースだった場合などによく使う。
        //.data(forKey: "savedActions"), キーsavedActionsに関連付けられたデータを取得している。
        guard let decodedData = userDefaults.data(forKey: "savedActions"),
              //try?は、NSKeyedUnarchiver.unarchiveTopLevelObjectWithDataがエラーを投げる可能性があるため、それをオプショナルで扱う構文です。エラーが発生した場合はnilを返す。
              //NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData)は、decodedDataを使ってオブジェクトをデコードしようとしている。
              //as?
              //as? [ActionModel]は、デコードされたオブジェクト（保存されていたデータを元の状態に戻した結果のオブジェクトを指します。）を　   　[ActionModel]型にキャストしようとします。このキャストが失敗した場合はnilを返す。
              //else { return }は、もしデコードやキャストが失敗した場合、現在のスコープ（通常は関数やメソッド）から抜けることを意味する。
              let savedActions = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as? [ActionModel] else {
            return
        }
        
        // ベースビューの設定 バックグランドカラー　ホワイト
        view.backgroundColor = .white
        
        // 歌詞とアクションを配置するためのスタートY位置
        var yOffset: CGFloat = 100
        
        // 歌詞を1行ずつ表示し、その下に絵文字を追加
        //enumerated イニューメレイテッド　列挙された
        for (index, line) in lyrics.enumerated() {
            // ラベルの作成
            //UILabelのインスタンス化
            let label = UILabel()
            //UILabelのtextプロパティ　にlineを代入
            label.text = line
            //UILabelの行数プロパティ　に0を代入
            label.numberOfLines = 0
            //label.frame　ラベルのフレーム（位置とサイズ）を設定
            //x: 20は、ラベルの左上隅のx座標を20ピクセルに設定
            //y: yOffsetは、ラベルの左上隅のy座標をyOffset変数の値に設定
            //width: view.frame.width - 40は、ラベルの幅をviewの幅から40ピクセル引いた値に設定（左右のマージンを20ピクセルずつ確保）。
            //height: 30は、ラベルの高さを30ピクセルに設定
            label.frame = CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 30)
            //viewは、ラベルを追加する親ビュ-
            //addSubview(label)は、viewに対してlabelをサブビューとして追加します。これにより、labelがviewの中に表示される
            view.addSubview(label)
            
            // 次のY位置の更新
            yOffset += 40
            
            //対応する絵文字ラベルの作成
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
                
                view.addSubview(emojiLabel)
            }
            
            // 次のY位置の更新
            yOffset += 50
        }
    }
}

// AppDelegate.swiftに以下を追加して、このViewControllerを初期ビューコントローラとして設定
//このアノテーションは、アプリケーションのエントリーポイントを指定します。Swiftでは、@ mainアノテーションが付いたクラスがアプリケーションの起動時に実行されます。
@main
//AppDelegateは、アプリケーションのライフサイクルイベントを処理するためのデリゲートクラスです。UIResponderを継承し、UIApplicationDelegateプロトコルに準拠しています。
class AppDelegate: UIResponder, UIApplicationDelegate {
    //windowはアプリケーションのメインウィンドウを示すプロパティです。アプリ全体のビュー階層を管理します。
    var window: UIWindow?
    //このメソッドは、アプリケーションが起動した後に呼び出されます。起動時のカスタム設定や初期化を行う場所です。
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //新しいUIWindowインスタンスを作成し、画面全体をカバーするようにそのフレームを設定しています。
        window = UIWindow(frame: UIScreen.main.bounds)
        //アプリケーションの最初のビューコントローラとしてLyricsViewControllerを設定します。これにより、アプリが起動するとLyricsViewControllerが最初に表示されます。
        window?.rootViewController = LyricsViewController()
        //ウィンドウを表示し、アプリケーションのメインウィンドウとして設定します。
        window?.makeKeyAndVisible()
        //アプリケーションの起動が正常に完了したことを示します。
        return true
    }
}
