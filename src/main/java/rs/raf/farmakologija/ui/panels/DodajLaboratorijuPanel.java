package rs.raf.farmakologija.ui.panels;

import rs.raf.farmakologija.dao.LaboratorijaDao;
import rs.raf.farmakologija.model.Biosafety;
import rs.raf.farmakologija.ui.UiUtil;

import javax.swing.*;
import java.awt.*;
import java.sql.SQLException;

public class DodajLaboratorijuPanel extends JPanel {

    private final LaboratorijaDao dao;

    private final JTextField nazivField        = new JTextField(20);
    private final JTextField zgradaField       = new JTextField(20);
    private final JTextField spratField        = new JTextField(5);
    private final JTextField brProstorijeField = new JTextField(10);
    private final JComboBox<Biosafety> biosafetyBox = new JComboBox<>();

    private Runnable onLabAdded;

    public DodajLaboratorijuPanel(LaboratorijaDao dao) {
        this.dao = dao;
        setLayout(new BorderLayout());
        buildUi();
        loadBiosafety();
    }

    public void setOnLabAdded(Runnable callback) {
        this.onLabAdded = callback;
    }

    private void buildUi() {
        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(6, 6, 6, 6);
        c.anchor = GridBagConstraints.WEST;

        String[] labels = {"Naziv:", "Zgrada:", "Sprat:", "Br. prostorije:", "Biosafety nivo:"};
        JComponent[] fields = {nazivField, zgradaField, spratField, brProstorijeField, biosafetyBox};

        for (int i = 0; i < labels.length; i++) {
            c.gridx = 0; c.gridy = i; c.fill = GridBagConstraints.NONE;
            form.add(new JLabel(labels[i]), c);
            c.gridx = 1; c.fill = GridBagConstraints.HORIZONTAL;
            form.add(fields[i], c);
        }

        JButton dodajBtn = new JButton("Dodaj laboratoriju");
        dodajBtn.addActionListener(e -> dodaj());

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttons.add(dodajBtn);

        c.gridx = 0; c.gridy = labels.length;
        c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(buttons, c);

        add(form, BorderLayout.NORTH);
    }

    private void loadBiosafety() {
        try {
            biosafetyBox.removeAllItems();
            for (Biosafety b : dao.findAllBiosafety()) {
                biosafetyBox.addItem(b);
            }
        } catch (SQLException ex) {
            UiUtil.showError(this, "Greška pri učitavanju biosafety nivoa", ex);
        }
    }

    private void dodaj() {
        String naziv    = nazivField.getText().trim();
        String zgrada   = zgradaField.getText().trim();
        String spratStr = spratField.getText().trim();
        String brProst  = brProstorijeField.getText().trim();
        Biosafety biosafety = (Biosafety) biosafetyBox.getSelectedItem();

        if (naziv.isEmpty() || zgrada.isEmpty() || spratStr.isEmpty() || brProst.isEmpty()) {
            UiUtil.showWarn(this, "Sva polja su obavezna.");
            return;
        }

        int sprat;
        try {
            sprat = Integer.parseInt(spratStr);
        } catch (NumberFormatException ex) {
            UiUtil.showWarn(this, "Sprat mora biti broj.");
            return;
        }

        try {
            String poruka = dao.dodaj(naziv, zgrada, sprat, brProst, biosafety.biosafetyId());
            if (poruka != null && poruka.toLowerCase().contains("uspesno")) {
                UiUtil.showInfo(this, poruka);
                clearFields();
                if (onLabAdded != null) onLabAdded.run();
            } else {
                UiUtil.showWarn(this, poruka != null ? poruka : "Nepoznata greška.");
            }
        } catch (SQLException ex) {
            UiUtil.showError(this, "Greška pri dodavanju", ex);
        }
    }

    private void clearFields() {
        nazivField.setText("");
        zgradaField.setText("");
        spratField.setText("");
        brProstorijeField.setText("");
        biosafetyBox.setSelectedIndex(0);
    }
}