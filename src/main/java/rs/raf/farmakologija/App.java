package rs.raf.farmakologija;

import rs.raf.farmakologija.auth.UserStore;
import rs.raf.farmakologija.ui.LoginFrame;

import javax.swing.*;

public class App {

    public static void main(String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        UserStore userStore = new UserStore();
        SwingUtilities.invokeLater(() -> new LoginFrame(userStore).setVisible(true));
    }
}
