package rs.raf.farmakologija.ui;

import rs.raf.farmakologija.auth.UserStore;

import javax.swing.*;
import java.awt.*;
import java.io.IOException;

public class SignupFrame extends JFrame {

    private final UserStore userStore;
    private final JTextField usernameField = new JTextField(18);
    private final JPasswordField passwordField = new JPasswordField(18);
    private final JPasswordField confirmField = new JPasswordField(18);

    public SignupFrame(UserStore userStore) {
        super("Registracija — Pretklinička farmakologija");
        this.userStore = userStore;
        buildUi();
    }

    private void buildUi() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(440, 290);
        setLocationRelativeTo(null);

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(6, 6, 6, 6);
        c.anchor = GridBagConstraints.WEST;

        c.gridx = 0; c.gridy = 0;
        form.add(new JLabel("Korisničko ime:"), c);
        c.gridx = 1; form.add(usernameField, c);

        c.gridx = 0; c.gridy = 1;
        form.add(new JLabel("Lozinka:"), c);
        c.gridx = 1; form.add(passwordField, c);

        c.gridx = 0; c.gridy = 2;
        form.add(new JLabel("Potvrda lozinke:"), c);
        c.gridx = 1; form.add(confirmField, c);

        JButton backBtn = new JButton("Nazad na prijavu");
        JButton registerBtn = new JButton("Registruj se");
        backBtn.addActionListener(e -> backToLogin());
        registerBtn.addActionListener(e -> tryRegister());

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttons.add(backBtn);
        buttons.add(registerBtn);

        c.gridx = 0; c.gridy = 3; c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(buttons, c);

        getRootPane().setDefaultButton(registerBtn);
        setContentPane(form);
    }

    private void tryRegister() {
        String username = usernameField.getText().trim();
        String password = new String(passwordField.getPassword());
        String confirm = new String(confirmField.getPassword());

        if (username.isEmpty() || password.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Polja ne smeju biti prazna.",
                    "Greška", JOptionPane.WARNING_MESSAGE);
            return;
        }
        if (!password.equals(confirm)) {
            JOptionPane.showMessageDialog(this, "Lozinke se ne poklapaju.",
                    "Greška", JOptionPane.WARNING_MESSAGE);
            return;
        }
        if (userStore.exists(username)) {
            JOptionPane.showMessageDialog(this, "Korisničko ime je već zauzeto.",
                    "Greška", JOptionPane.ERROR_MESSAGE);
            return;
        }

        try {
            userStore.register(username, password);
            JOptionPane.showMessageDialog(this, "Uspešna registracija. Možete se prijaviti.",
                    "Info", JOptionPane.INFORMATION_MESSAGE);
            backToLogin();
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "Greška pri upisu: " + ex.getMessage(),
                    "Greška", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void backToLogin() {
        LoginFrame login = new LoginFrame(userStore);
        login.setVisible(true);
        dispose();
    }
}
