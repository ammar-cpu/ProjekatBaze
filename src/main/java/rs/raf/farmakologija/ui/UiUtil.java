package rs.raf.farmakologija.ui;

import javax.swing.*;
import java.awt.*;

public final class UiUtil {

    private UiUtil() {}

    public static void showError(Component parent, String title, Exception ex) {
        String msg = ex.getMessage() == null ? ex.getClass().getSimpleName() : ex.getMessage();
        JOptionPane.showMessageDialog(parent, msg, title, JOptionPane.ERROR_MESSAGE);
    }

    public static void showWarn(Component parent, String msg) {
        JOptionPane.showMessageDialog(parent, msg, "Upozorenje", JOptionPane.WARNING_MESSAGE);
    }

    public static void showInfo(Component parent, String msg) {
        JOptionPane.showMessageDialog(parent, msg, "Info", JOptionPane.INFORMATION_MESSAGE);
    }

    public static boolean confirm(Component parent, String msg) {
        return JOptionPane.showConfirmDialog(parent, msg, "Potvrda",
                JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION;
    }
}
