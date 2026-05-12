package rs.raf.farmakologija.ui;

import rs.raf.farmakologija.auth.UserStore;
import rs.raf.farmakologija.db.DatabaseConnection;
import rs.raf.farmakologija.ui.panels.BrisanjeLaboratorijePanel;
import rs.raf.farmakologija.ui.panels.IzmenaSesijePanel;
import rs.raf.farmakologija.ui.panels.PregledSesijaPanel;
import rs.raf.farmakologija.ui.panels.SamostalniUpitPanel;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.SQLException;

public class AdminMainFrame extends JFrame {

    private final String username;

    public AdminMainFrame(String username) {
        super("Administracija — Pretklinička farmakologija");
        this.username = username;
        buildUi();
    }

    private void buildUi() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(1000, 650);
        setLocationRelativeTo(null);

        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Pregled sesija", new PregledSesijaPanel());
        tabs.addTab("Izmena sesije", new IzmenaSesijePanel());
        tabs.addTab("Brisanje laboratorije", new BrisanjeLaboratorijePanel());
        tabs.addTab("Samostalni upit", new SamostalniUpitPanel());

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

    private String connectionStatus() {
        try (Connection c = DatabaseConnection.get()) {
            return "DB: OK";
        } catch (SQLException e) {
            return "DB: nepovezano";
        }
    }

    private void logout() {
        new LoginFrame(new UserStore()).setVisible(true);
        dispose();
    }
}
