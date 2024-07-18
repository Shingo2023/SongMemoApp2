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
    
    //リリックビューに遷移するコード　今回提供されたコード
    // UITableViewDelegate メソッド - テーブルビューの行が選択された時に呼び出されるメソッド
    func presentLyricsView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // メインストーリーボードを読み込む
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           // LyricsViewController をストーリーボードからインスタンス化
           let lyricsVC = storyboard.instantiateViewController(withIdentifier: "LyricsViewController") as! LyricsViewController
           // 選択された SongTextModel を LyricsViewController に渡す
           lyricsVC.songTextModel = songList[indexPath.row]
           // LyricsViewController に画面遷移する
           self.navigationController?.pushViewController(lyricsVC, animated: true)
       }
    
    
        //押されたらアクションビューに画面遷移するメソッド
        //接続名　クリエイトアクション　引数　は　UIButton
    @IBAction func createAction(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "ActionEditViewController", bundle: nil)
            //VCとはviewControllerの略 （つまりこの定数に格納している） = インスタンス（初期化）するViewは (ActionViewController) 強制キャスト　型名（ActionViewController）
            let actionVC = storyboard.instantiateViewController(withIdentifier: "ActionEditViewController") as! ActionEditViewController
            //UIkitのUIViewControllerに所属するnavigationController nilのとき（navigationControllerが存在しない場合）スキップする . ビューコントローラが所属するナビゲーションコントローラ(pushされるview, アニメーション付き)
            self.navigationController?.pushViewController(actionVC, animated: true)
        }

          // データソースメソッド - テーブルビューの行数を決定するメソッド
          // (_ 引数ラベルの省略: 引数名, データソースプロトコルの一部 セクションのインデックス: 引数はInt型) ->　戻り値もInt型
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //戻り値　ソングリストの数
            return songList.count
        }
         // データソースメソッド - テーブルビューの各行に対するセルを提供するメソッド
         // (_ 引数ラベルの省略 引数名: UITableView型, データソースプロトコルの一部  インデックスパス: インデックスパス型) 戻り値はUITableViewCell型　このUITableViewCellは存在しないが必要な記述らしい
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //セルの再利用
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
            //セルに曲名を設定
            cell.textLabel?.text = songList[indexPath.row].text
            //セルを返す
            return cell
        }

        // UITableViewDelegate メソッド
        // (引数ラベル　引数名　型, プロトコル インデックスパス: インデックスパス型)
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //定数 storyboard　は　UIstoryboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //歌詞のVC　は　インスタントシエート(作成)ビュー　強制キャスト　型名
            let lyricsVC = storyboard.instantiateViewController(withIdentifier: "LyricsViewController") as! LyricsViewController
            //歌詞のVC　モデル　は　ソングリスト(配列の行番号を取得)
            lyricsVC.songTextModel = songList[indexPath.row]
            //navigationControllerがnilの時スキップ.プッシュビューコントローラー（歌詞の略:アニメーション付き）
            //pushViewControllerとはUINavigationControllerのインスタンスメソッド
            self.navigationController?.pushViewController(lyricsVC, animated: true)
        }
    }
