1. 開発環境について
 * FlexSDK 3.4
 http://opensource.adobe.com/wiki/display/flexsdk/download?build=3.4.0.9271&pkgtype=1
 * FlexPMD(コードチェック)
 http://opensource.adobe.com/wiki/display/flexpmd/Downloads

2. コンパイル環境について
 前提：ant がインストールされていること
 # ant -buildfile build/build.xml
 もしくは
 # cd build
 # ant (antだけで良い)
 これにより、bin ディレクトリに swf が作成されます
 または、コードチェックやASDOCの生成も同時に行いたい場合は
 # ant all
 として下さい
 なお、通常の build タスク、及び all タスクでは trace ログが出力されません。
 以下のように budeg-build 及び debug-all で trace ログが出力されるバイナリが出来ます。
 # ant debug-build

3. 生成された pmd.xml について
 以下のサイトでアップロードすると見れるようになります。
 http://opensource.adobe.com/svn/opensource/flexpmd/bin/flex-pmd-violations-viewer.html
 また、コードチェックで行うルールを独自に作成したい場合は下記でルールファイルを作成できます
 http://opensource.adobe.com/svn/opensource/flexpmd/bin/flex-pmd-ruleset-creator.html

4. XML メモ
* 働き時間
	* 年
		* 月
		* 時間
		* コメント
	* 年
		* 月
		* 時間
		* コメント
	* 年
		* 月
		* 時間
		* コメント
* ユーザ情報（職業情報）
* 最大の時間
* 最小の時間

