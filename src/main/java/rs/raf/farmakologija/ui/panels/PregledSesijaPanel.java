package rs.raf.farmakologija.ui.panels;

import rs.raf.farmakologija.dao.SesijaDao;
import rs.raf.farmakologija.ui.SesijaPregledTableModel;
import rs.raf.farmakologija.ui.UiUtil;

import javax.swing.*;
import java.awt.*;
import java.sql.SQLException;

public class PregledSesijaPanel extends JPanel {

    private final SesijaDao dao = new SesijaDao();
    private final SesijaPregledTableModel model = new SesijaPregledTableModel();
    private final JTable table = new JTable(model);

    public PregledSesijaPanel() {
        setLayout(new BorderLayout());
        table.setAutoCreateRowSorter(true);
        table.getTableHeader().setReorderingAllowed(false);

        JButton refreshBtn = new JButton("Osveži");
        refreshBtn.addActionListener(e -> refresh(true));

        JPanel top = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        top.add(refreshBtn);

        add(top, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);

        refresh(false);
    }

    private void refresh(boolean showErrors) {
        try {
            model.setData(dao.findAllForPregled());
        } catch (SQLException ex) {
            if (showErrors) UiUtil.showError(this, "Greška pri učitavanju sesija", ex);
        }
    }
}
