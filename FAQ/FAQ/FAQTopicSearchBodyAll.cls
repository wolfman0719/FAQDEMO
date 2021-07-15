Class FAQ.FAQTopicSearchBodyAll Extends FAQ.FAQTopicSearchBodyTemplate
{

/// このページが属するアプリケーションのクラス名です。
Parameter APPLICATION = "FAQ.FAQApp";

/// このページの表示名です。
Parameter PAGENAME = "InterSystems FAQ";

/// ローカライズで使用されるドメインです。
Parameter DOMAIN;

/// この Style ブロックにはページ固有のCSSスタイル定義を記述します。
XData Style
{
<style type="text/css">
</style>
}

Property Product As %String [ InitialExpression = 99 ];

}
