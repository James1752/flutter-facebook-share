package co.yodelit.facebook_share;

public class ShareLinkData {
    private final String url;
    private final String quote;
    private final String hashTag;

    ShareLinkData(String url, String quote, String hashTag){
        this.url = url;
        this.quote = quote;
        this.hashTag = hashTag;
    }

    public String getUrl() {
        return url;
    }

    public String getQuote() {
        return quote;
    }

    public String getHashTag() {
        return hashTag;
    }
}
