package mMoin;

public class MmoinUtil {
	/**
	 * 암호화 키
	 */
	private static final String KEY = "m.MOIN.key";

	/**
	 * 복호화
	 * 
	 * @param encString
	 * @param charSet
	 * @return
	 */
	public static String dec(String encString, String charSet) {
		TripleDESCrypt crypt = new TripleDESCrypt(KEY, charSet);
		return crypt.hexDecrypt(encString, charSet);
	}

	/**
	 * 암호화
	 * 
	 * @param decString
	 * @param charSet
	 * @return
	 */
	public static String enc(String decString, String charSet) {
		TripleDESCrypt crypt = new TripleDESCrypt(KEY, charSet);
		return crypt.base64Encrypt(decString, charSet);
	}
}
