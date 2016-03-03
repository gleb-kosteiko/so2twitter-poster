public class SO2TP_TwitterUtil{
    public static final String[] SIGNATURE_KEYS = new String[]{
        'oauth_consumer_key', 
        'oauth_nonce', 
        'oauth_signature_method', 
        'oauth_timestamp', 
        'oauth_token', 
        'oauth_version', 
        'status'
    };
        
    public static final String[] OAUTH_KEYS = new String[]{
        'oauth_consumer_key',
        'oauth_nonce',
        'oauth_signature',
        'oauth_signature_method',
        'oauth_timestamp',
        'oauth_token',
        'oauth_version'
    };

    public String algorithmName{
        get{
            if(algorithmName == null)
                return 'hmacSHA1';
            return algorithmName;
        } 
        set;}
    public String oauth_signature_method{
        get{
            if(oauth_signature_method == null)
                return 'HMAC-SHA1';
            return oauth_signature_method;
        }
        set;}
    public String oauth_version{
        get {
            if(oauth_version == null)
                oauth_version = '1.0';
            return oauth_version;
        } 
        set;}          
    public String http_method {get; set;}
    public String base_url {get; set;}
    public String status {get; set;}
    public String oauth_consumer_key {get; set;}
    public String oauth_consumer_secret {get; set;}
    public String oauth_token {get; set;}
    public String oauth_token_secret {get; set;}
    
    public String oauth_nonce {get; private set;}
    public String oauth_signature {get; private set;}
    public String oauth_timestamp {
        get {
            if(oauth_timestamp == null)
                oauth_timestamp = String.valueOf(DateTime.now().getTime()/1000);
            return oauth_timestamp;
        }
        private set;}
    
    private map<String, String> signaturePairs {get; set;}
    private String parameterString {get; set;}
    private String signatureBaseString {get; set;}
    private String signingKey {get; set;}
    private String oauth_header {get; set;}
    private String http_body {get; set;}
    
    public SO2TP_TwitterUtil () {}
    
    public SO2TP_TwitterUtil(String oauth_consumer_key, String oauth_consumer_secret, 
            String oauth_token, String oauth_token_secret) {
        this.oauth_consumer_key = oauth_consumer_key;
        this.oauth_consumer_secret = oauth_consumer_secret;
        this.oauth_token = oauth_token;
        this.oauth_token_secret = oauth_token_secret;
    }
    
    public Boolean sendTweet(String status, map<String, String> additionalParams){
        if(this.oauth_consumer_key == null ||
                this.oauth_consumer_secret == null ||
                this.oauth_token == null || 
                this.oauth_token_secret == null)
            return false;
        
        this.http_method = 'POST';
        this.base_url = 'https://api.twitter.com/1.1/statuses/update.json';
        this.status = status;
        generateNonce();
        initializeSignatureKeyValuePairs(additionalParams);
        generateOauthSignature();
        generateOauthHeader();
        generateHttpBody(additionalParams);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(this.http_method);
        req.setEndpoint(this.base_url);
        req.setBody(this.http_body);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-Length', String.valueOf(req.getBody().length()));
        req.setHeader('Authorization', this.oauth_header);

        try {
            HttpResponse res = h.send(req);           
            if(res.getStatusCode() == 200)
                return true;
            else 
                return false;
        } catch (CalloutException e) {
            return false;
        }
        return true;
    }
    
    private void generateNonce() {
        String validChars = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Integer len = validChars.length();
        String randomString = '';        
        for(Integer i=0; i<32; i++) {
            Integer rInt = Integer.valueOf(Math.rint(Math.random()*(len-1)));
            randomString += validChars.substring(rInt, rInt+1);
        }
        this.oauth_nonce = randomString;
    }
    
    private void initializeSignatureKeyValuePairs(map<String, String> additionalParams) {
        this.signaturePairs = new map<String, String>();
        this.signaturePairs.put('status', this.status);
        this.signaturePairs.put('oauth_consumer_key', this.oauth_consumer_key);
        this.signaturePairs.put('oauth_nonce', this.oauth_nonce);
        this.signaturePairs.put('oauth_signature_method', this.oauth_signature_method);
        this.signaturePairs.put('oauth_timestamp', this.oauth_timestamp);
        this.signaturePairs.put('oauth_token', this.oauth_token);
        this.signaturePairs.put('oauth_version', this.oauth_version);
        if(additionalParams != null && additionalParams.keySet().size() > 0) {
            for(String key : additionalParams.keySet()) {
                if(!this.signaturePairs.containsKey(key) && additionalParams.get(key) != null) {
                    //system.debug('**** adding key: ' + key + ' and value: ' + additionalParams.get(key));
                    this.signaturePairs.put(key, additionalParams.get(key));
                    SIGNATURE_KEYS.add(key);
                }
            }
        }
        SIGNATURE_KEYS.sort();
    }
    
    private void generateOauthSignature() {
        this.parameterString = createParameterString();
        this.signatureBaseString = createSignatureBaseString();
        this.signingKey = createSigningKey();
        this.oauth_signature = createOauthSignature();
    }
    
    private String createParameterString() {
        String paramString = '';
        system.debug(json.serializepretty(signaturePairs));
        for(String key : SIGNATURE_KEYS) {
            paramString += SO2TP_StringUtil.percentEncode(key);
            paramString += '=';
            paramString += SO2TP_StringUtil.percentEncode(signaturePairs.get(key));
            paramString += '&';
        }
        paramString = removeLastNLetters(paramString, 1);
        system.debug('**** Parameter String');
        system.debug(paramString);
        return paramString;
    }
    
    private String createSignatureBaseString() {
        String sigBase = '';
        sigBase += this.http_method.toUpperCase() ;
        sigBase += '&';
        sigBase += SO2TP_StringUtil.percentEncode(this.base_url);
        sigBase += '&';
        sigBase += SO2TP_StringUtil.percentEncode(this.parameterString);
        system.debug('**** Signature Base String');
        system.debug(sigBase);
        return sigBase;
    }
    
    private String createSigningKey() {
        String signKey = SO2TP_StringUtil.percentEncode(this.oauth_consumer_secret);
        signKey += '&';
        signKey += SO2TP_StringUtil.percentEncode(this.oauth_token_secret);
        system.debug('**** Signing Key');
        system.debug(signKey);
        return signKey;
    }
    
    private String createOauthSignature() {
        Blob mac = Crypto.generateMac(this.algorithmName, 
                Blob.valueOf(this.signatureBaseString), Blob.valueOf(this.signingKey)); 
        string hashedValue = EncodingUtil.convertToHex(mac);
        String oauthSig = EncodingUtil.base64Encode(mac);
        system.debug('**** Hashed Value');
        system.debug(hashedValue);
        system.debug('**** Oauth Signature');
        system.debug(oauthSig);
        return oauthSig;  
    }
    
    private void generateOauthHeader() {
        map<String, String> oauthParams = new map<String, String>();
        oauthParams.put('oauth_consumer_key', this.oauth_consumer_key);
        oauthParams.put('oauth_nonce', this.oauth_nonce);
        oauthParams.put('oauth_signature', this.oauth_signature);
        oauthParams.put('oauth_signature_method', this.oauth_signature_method);
        oauthParams.put('oauth_timestamp', this.oauth_timestamp);
        oauthParams.put('oauth_version', this.oauth_version);
        oauthParams.put('oauth_token', this.oauth_token);
        String header = 'OAuth ';
        for(String key : OAUTH_KEYS) {
            header += SO2TP_StringUtil.percentEncode(key);
            header += '="';
            header += SO2TP_StringUtil.percentEncode(oauthParams.get(key));
            header += '", ';
        }
        this.oauth_header = removeLastNLetters(header, 2);
        system.debug('**** Oauth Header');
        system.debug(this.oauth_header);
    }
    
    private void generateHttpBody(map<String, String> additionalParams) {
        String httpBody = 'status='+EncodingUtil.urlEncode(this.status, 'UTF-8');
        if(additionalParams != null && additionalParams.keySet() != null) {
            for(String key : additionalParams.keySet()) {
                if(additionalParams.get(key) != null) {
                    httpBody += '&';
                    httpBody += EncodingUtil.urlEncode(key, 'UTF-8');
                    httpBody += '=';
                    httpBody += EncodingUtil.urlEncode(additionalParams.get(key), 'UTF-8');
                }
            }
        }
        this.http_body = httpBody.replace('*', '%2A');
        system.debug('**** Request Body: ');
        system.debug(this.http_body);
    }
    
    private static String removeLastNLetters(String source, Integer numToRemove) {
        return source.subString(0, source.length()-numToRemove);
    }
}