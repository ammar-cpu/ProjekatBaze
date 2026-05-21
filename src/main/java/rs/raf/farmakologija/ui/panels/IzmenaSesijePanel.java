package rs.raf.farmakologija.ui.panels;

import rs.raf.farmakologija.dao.SesijaDao;
import rs.raf.farmakologija.model.SesijaPregled;
import rs.raf.farmakologija.ui.UiUtil;

import javax.swing.*;
import java.awt.*;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

public class IzmenaSesijePanel extends JPanel {

    private final SesijaDao dao = new SesijaDao();

    private final JComboBox<SesijaPregled> sesijaBox = new JComboBox<>();
    private final JTextField datumField    = new JTextField(12);
    private final JTextField pocetakField  = new JTextField(8);
    private final JTextField zavrsetakField = new JTextField(8);

    public IzmenaSesijePanel() {
        setLayout(new BorderLayout());

        sesijaBox.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value,
                    int index, boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                if (value instanceof SesijaPregled s) {
                    setText("#" + s.sesijaId() + " — " + s.eksperiment()
                            + " (" + s.datum() + " " + s.pocetak() + ")");
                }
                return this;
            }
        });
        sesijaBox.addActionListener(e -> loadSelected());

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(6, 6, 6, 6);
        c.anchor = GridBagConstraints.WEST;

        c.gridx = 0; c.gridy = 0;
        form.add(new JLabel("Sesija:"), c);
        c.gridx = 1; c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(sesijaBox, c);

        c.gridwidth = 1; c.fill = GridBagConstraints.NONE;
        c.gridx = 0; c.gridy = 1;
        form.add(new JLabel("Novi datum (YYYY-MM-DD):"), c);
        c.gridx = 1; form.add(datumField, c);

        c.gridx = 0; c.gridy = 2;
        form.add(new JLabel("Novi početak (HH:mm):"), c);
        c.gridx = 1; form.add(pocetakField, c);

        c.gridx = 0; c.gridy = 3;
        form.add(new JLabel("Novi završetak (HH:mm):"), c);
        c.gridx = 1; form.add(zavrsetakField, c);

        JLabel info = new JLabel(
            "<html><i>Procedura automatski proverava preklapanje termina u laboratoriji.</i></html>");
        info.setForeground(Color.GRAY);
        c.gridx = 0; c.gridy = 4; c.gridwidth = 2;
        form.add(info, c);

        JButton refreshBtn = new JButton("Osveži listu");
        JButton saveBtn    = new JButton("Sačuvaj izmene");
        refreshBtn.addActionListener(e -> refresh(true));
        saveBtn.addActionListener(e -> save());

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttons.add(refreshBtn);
        buttons.add(saveBtn);

        c.gridx = 0; c.gridy = 5; c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(buttons, c);

        add(form, BorderLayout.NORTH);
        refresh(false);
    }

    private void refresh(boolean showErrors) {
        try {
            sesijaBox.removeAllItems();
            for (SesijaPregled s : dao.findAllForPregled()) {
                sesijaBox.addItem(s);
            }
        } catch (SQLException ex) {
            if (showErrors) UiUtil.showError(this, "Greška pri učitavanju", ex);
        }
    }

    private void loadSelected() {
        SesijaPregled s = (SesijaPregled) sesijaBox.getSelectedItem();
        if (s == null) return;
        datumField.setText(s.datum().toString());
        pocetakField.setText(s.pocetak().toString());
        zavrsetakField.setText(s.zavrsetak().toString());
    }

    private void save() {
        SesijaPregled selected = (SesijaPregled) sesijaBox.getSelectedItem();
        if (selected == null) { UiUtil.showWarn(this, "Izaberite sesiju."); return; }

        try {
            LocalDate  datum     = LocalDate.parse(datumField.getText().trim());
            LocalTime  pocetak   = LocalTime.parse(pocetakField.getText().trim());
            LocalTime  zavrsetak = LocalTime.parse(zavrsetakField.getText().trim());

            if (!zavrsetak.isAfter(pocetak)) {
                UiUtil.showWarn(this, "Završetak mora biti posle početka.");
                return;
            }

            String poruka = dao.izmeni(selected.sesijaId(), datum, pocetak, zavrsetak);

            if (poruka != null && poruka.toLowerCase().contains("uspesno")) {
                UiUtil.showInfo(this, poruka);
                refresh(true);
            } else {
                UiUtil.showWarn(this, poruka != null ? poruka : "Nepoznata greška.");
            }

        } catch (DateTimeParseException ex) {
            UiUtil.showWarn(this, "Neispravan format datuma ili vremena. Koristite YYYY-MM-DD i HH:mm.");
        } catch (SQLException ex) {
            UiUtil.showError(this, "Greška pri izmeni", ex);
        }
    }
}
