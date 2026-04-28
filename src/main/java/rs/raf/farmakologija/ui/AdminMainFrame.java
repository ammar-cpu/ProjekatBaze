package rs.raf.farmakologija.ui;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.SQLException;

import rs.raf.farmakologija.db.DatabaseConnection;

public class AdminMainFrame extends JFrame {

    private final String username;

    public AdminMainFrame(String username) {
        super("Administracija — Pretklinička farmakologija");
        this.username = username;
        buildUi();
    }

    private void buildUi() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(900, 600);
        setLocationRelativeTo(null);

        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Pregled sesija", placeholder("Forma za pregled zakazanih sesija i eksperimenata."));
        tabs.addTab("Izmena sesije", placeholder("Forma za promenu podataka o sesiji."));
        tabs.addTab("Brisanje laboratorije", placeholder("Forma za brisanje laboratorije (samo ako u njoj ne radi nijedan istraživač)."));
        tabs.addTab("Samostalni upit", placeholder("Tvoj samostalni upit nad farmakološkom specifikacijom."));

        JLabel status = new JLabel("Prijavljen kao: " + username + "  |  " + connectionStatus());
        status.setBorder(BorderFactory.createEmptyBorder(6, 10, 6, 10));

        JButton logoutBtn = new JButton("Odjava");
        logoutBtn.addActionListener(e -> logout());

        JPanel topBar = new JPanel(new BorderLayout());
        topBar.add(status, BorderLayout.WEST);
        JPanel right = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        right.add(logoutBtn);
        topBar.add(right, BorderLayout.EAST);

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(topBar, BorderLayout.NORTH);
        getContentPane().add(tabs, BorderLayout.CENTER);
    }

    private JComponent placeholder(String text) {
        JLabel lbl = new JLabel("<html><div style='padding:30px;color:#666'>TODO: " + text + "</div></html>");
        lbl.setHorizontalAlignment(SwingConstants.CENTER);
        return lbl;
    }

    private String connectionStatus() {
        try (Connection c = DatabaseConnection.get()) {
            return "DB: OK";
        } catch (SQLException e) {
            return "DB: nepovezano (" + e.getMessage() + ")";
        }
    }

    private void logout() {
        new LoginFrame(new rs.raf.farmakologija.auth.UserStore()).setVisible(true);
        dispose();
    }
}
