package rs.raf.farmakologija.ui.panels;

import rs.raf.farmakologija.dao.IstrazivacDao;
import rs.raf.farmakologija.dao.LaboratorijaDao;
import rs.raf.farmakologija.model.Laboratorija;
import rs.raf.farmakologija.ui.UiUtil;

import javax.swing.*;
import java.awt.*;
import java.sql.SQLException;

public class BrisanjeLaboratorijePanel extends JPanel {

    private final LaboratorijaDao labDao;
    private final IstrazivacDao   istrazivacDao = new IstrazivacDao();

    private final JComboBox<Laboratorija> labBox = new JComboBox<>();

    public BrisanjeLaboratorijePanel(LaboratorijaDao labDao) {
        this.labDao = labDao;
        setLayout(new BorderLayout());

        labBox.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value,
                                                          int index, boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                if (value instanceof Laboratorija l) {
                    setText("#" + l.labId() + " — " + l.naziv());
                }
                return this;
            }
        });

        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(6, 6, 6, 6);
        c.anchor = GridBagConstraints.WEST;

        c.gridx = 0; c.gridy = 0;
        form.add(new JLabel("Laboratorija:"), c);
        c.gridx = 1; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(labBox, c);

        JLabel info = new JLabel(
                "<html><i>Brisanje je dozvoljeno samo ako u laboratoriji ne radi nijedan istraživač.</i></html>");
        info.setForeground(Color.GRAY);

        JButton refreshBtn = new JButton("Osveži");
        JButton deleteBtn  = new JButton("Obriši");
        refreshBtn.addActionListener(e -> refresh());
        deleteBtn.addActionListener(e -> delete());

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttons.add(refreshBtn);
        buttons.add(deleteBtn);

        c.gridx = 0; c.gridy = 1; c.gridwidth = 2; c.fill = GridBagConstraints.HORIZONTAL;
        form.add(info, c);
        c.gridy = 2;
        form.add(buttons, c);

        add(form, BorderLayout.NORTH);
        refresh();
    }

    public void refresh() {
        try {
            labBox.removeAllItems();
            for (Laboratorija l : labDao.findAll()) labBox.addItem(l);
        } catch (SQLException ex) {
            UiUtil.showError(this, "Greška pri učitavanju laboratorija", ex);
        }
    }

    private void delete() {
        Laboratorija selected = (Laboratorija) labBox.getSelectedItem();
        if (selected == null) { UiUtil.showWarn(this, "Izaberite laboratoriju."); return; }

        try {
            int broj = istrazivacDao.countByLab(selected.labId());
            if (broj > 0) {
                UiUtil.showWarn(this, "Brisanje odbijeno: u laboratoriji '"
                        + selected.naziv() + "' radi " + broj + " istraživača.");
                return;
            }

            if (!UiUtil.confirm(this, "Sigurno obrisati laboratoriju '" + selected.naziv() + "'?")) return;

            String poruka = labDao.delete(selected.labId());
            if (poruka != null && poruka.toLowerCase().contains("uspesno")) {
                UiUtil.showInfo(this, poruka);
                refresh();
            } else {
                UiUtil.showWarn(this, poruka != null ? poruka : "Nepoznata greška.");
            }
        } catch (SQLException ex) {
            UiUtil.showError(this, "Greška pri brisanju", ex);
        }
    }
}