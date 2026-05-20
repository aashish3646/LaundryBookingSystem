package util;

public class ValidationUtil {
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String NAME_PATTERN = "^[A-Za-z ]+$";
    private static final String PHONE_PATTERN = "^[0-9]{7,15}$";

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidName(String name) {
        return !isEmpty(name) && name.trim().matches(NAME_PATTERN);
    }

    public static boolean isValidEmail(String email) {
        return !isEmpty(email) && email.trim().matches(EMAIL_PATTERN);
    }

    public static boolean isValidPhone(String phone) {
        return !isEmpty(phone) && phone.trim().matches(PHONE_PATTERN);
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isPositiveNumber(double number) {
        return number > 0;
    }

    public static boolean isPositiveInteger(int number) {
        return number > 0;
    }

    public static int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException | NullPointerException e) {
            return defaultValue;
        }
    }

    public static double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException | NullPointerException e) {
            return defaultValue;
        }
    }
}
