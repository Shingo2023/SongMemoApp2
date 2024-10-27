//
//  HomeViewController.swift
//  SongMemoApp2
//
//  Created by 高橋真悟 on 2024/05/03.
//
//モジュールをインポート　一般的にはフレームワークはUIKitを使っていると表現する
import UIKit
//クラス　モジュールに所属するUIViewControllerクラス。デリゲート、データソースプロトコルの呼び出し
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //IBOutlet接続　このUIViewを操作できる
    @IBOutlet weak var homeTableView: UITableView!
    //変数ソングリスト：　SongTextModel型　＝　[]変数の初期化　空の配列
        var songList: [SongTextModel] = []
        //ライサイクルメソッド　{} 内が２番目の挙動になる
        override func viewDidLoad() {
            //親クラスの初期化
            super.viewDidLoad()
            //デリゲートプロパティをself(Viewコントローラー自身)にしている
            homeTableView.delegate = self
            //データソースプロパティをself(Viewコントローラー自身)にしている
            homeTableView.dataSource = self
        }
    //アクションビューに画面遷移するメソッド
    //接続名　クリエイトアクション　引数　は　UIButton
    @IBAction func createAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ActionEditViewController", bundle: nil)
        //VCとはviewControllerの略 （つまりこの定数に格納している） = インスタンス（初期化）するViewは (ActionViewController) 強制キャスト　型名（ActionViewController）
        let actionVC = storyboard.instantiateViewController(withIdentifier: "ActionEditViewController") as! ActionEditViewController
        //UIkitのUIViewControllerに所属するnavigationController nilのとき（navigationControllerが存在しない場合）スキップする . ビューコントローラが所属するナビゲーションコントローラ(pushされるview, アニメーション付き)
        self.navigationController?.pushViewController(actionVC, animated: true)
    }
    
    //リリックビューに遷移するメソッド
    @IBAction func createLyrics(_ sender: UIButton) {
     
        let storyboard = UIStoryboard(name: "LyricsViewController", bundle: nil)
        //VCとはviewControllerの略 （つまりこの定数に格納している） = インスタンス（初期化）するViewは (ActionViewController) 強制キャスト　型名（LyricsViewController）
        let lyricsVC = storyboard.instantiateViewController(withIdentifier: "LyricsViewController") as! LyricsViewController
        //indexPathForSelectedRowは、UITableViewのプロパティで、選択された行のインデックスパス（IndexPath）を返します。これにより、アクションがトリガーされたときにテーブルビューのどの行が選択されているかを特定することができます。
        if let indexPath = homeTableView.indexPathForSelectedRow {
            //このコードの部分は、選択された行に対応するデータをLyricsViewControllerに渡す役割を果たしています。
            //LyricsViewControllerのインスタンス.モデル　＝ モデルのインスタンス[インデックス.row:行の要素]
                    lyricsVC.songTextModel = songList[indexPath.row]
                }
        //UIkitのUIViewControllerに所属するnavigationController nilのとき（navigationControllerが存在しない場合）スキップする . ビューコントローラが所属するナビゲーションコントローラ(pushされるview, アニメーション付き)
        self.navigationController?.pushViewController(lyricsVC, animated: true)
       }
    
          // numberOfRowsInSection UITableViewのデータソースメソッド - テーブルビューの行数を決定するメソッド
          // (_ 引数ラベルの省略: 引数名, データソースプロトコルの一部 セクションのインデックス: 引数はInt型) ->　戻り値もInt型
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //戻り値　ソングリストの数
            return songList.count
        }
         // cellForRowAt UITableViewのデータソースメソッド - テーブルビューの各行に対するセルを提供するメソッド
         //データソースメソッド リストやグリッド形式でデータを表示する際に使用されるメソッド
         // (_ 引数ラベルの省略 引数名: UITableView型, データソースプロトコルの一部  インデックスパス: インデックスパス型) 戻り値はUITableViewCell型　このUITableViewCellは存在しないが必要な記述らしい
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //dequeueReusableCell デキューリユーザブルセル　テーブビューのメソッド　セルの再利用ができる
            //withIdentifier: "SongCell" 作成するセルの識別子名
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath)
            //セルに曲名を設定
            cell.textLabel?.text = songList[indexPath.row].text
            //セルを返す
            return cell
        }

        // didSelectRowAt: UITableViewのデリゲートメソッド - テーブルビューの行が選択されたときに呼び出されます。これはユーザーの選択に対する応答として、特定の処理を実行するために使用されます。
        //デリゲートメソッド　オブジェクトの動作やイベントに応答するために使用されるメソッド
        // (引数ラベル　引数名　型, プロトコル インデックスパス: インデックスパス型)
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        }
    }
