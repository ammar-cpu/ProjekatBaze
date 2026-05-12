package rs.raf.farmakologija.ui;

import rs.raf.farmakologija.auth.UserStore;

import javax.swing.*;
import java.awt.*;

public class LoginFrame extends JFrame {

    private final UserStore userStore;
    private final JTextField usernameField = new JTextField(18);
    private final JPasswordField passwordField = new JPasswordField(18);

    public LoginFrame(UserStore userStore) {
        super("Prijava — Pretklinička farmakologija");
        this.userStore = userStore;
        buildUi();
    }

    private void buildUi() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(420, 260);
        setLocationRelativeTo(null);

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(6, 6, 6, 6);
        c.anchor = GridBagConstraints.WEST;

        c.gridx = 0; c.gridy = 0;
        form.add(new JLabel("Korisničko ime:"), c);
        c.gridx = 1;
        form.add(usernameField, c);

        c.gridx = 0; c.gridy = 1;
        form.add(new JLabel("Lozinka:"), c);
        c.gridx = 1;
        form.add(passwordField, c);

        JButton loginBtn = new JButton("Prijavi se");
        JButton signupBtn = new JButton("Registracija");
        loginBtn.addActionListener(e -> tryLogin());
        signupBtn.addActionListener(e -> openSignup());

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttons.add(signupBtn);
        buttons.add(loginBtn);

        c.gridx = 0; c.gridy = 2; c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(buttons, c);

        getRootPane().setDefaultButton(loginBtn);
        setContentPane(form);
    }

    private void tryLogin() {
        String username = usernameField.getText().trim();
        String password = new String(passwordField.getPassword());

        if (username.isEmpty() || password.isEmpty()) {
            UiUtil.showWarn(this, "Unesite korisničko ime i lozinku.");
            return;
        }

        if (!userStore.authenticate(username, password)) {
            JOptionPane.showMessageDialog(this, "Pogrešno korisničko ime ili lozinka.",
                    "Greška", JOptionPane.ERROR_MESSAGE);
            passwordField.setText("");
            return;
        }

        AdminMainFrame main = new AdminMainFrame(username);
        main.setVisible(true);
        dispose();
    }

    private void openSignup() {
        SignupFrame signup = new SignupFrame(userStore);
        signup.setVisible(true);
        dispose();
    }
}
