package rs.raf.farmakologija.ui;

import rs.raf.farmakologija.model.SesijaPregled;

import javax.swing.table.AbstractTableModel;
import java.util.ArrayList;
import java.util.List;

public class SesijaPregledTableModel extends AbstractTableModel {

    private static final String[] COLUMNS = {
            "ID", "Datum", "Početak", "Kraj", "Status sesije",
            "Eksperiment", "Laboratorija", "Status izvođenja"
    };

    private List<SesijaPregled> data = new ArrayList<>();

    public void setData(List<SesijaPregled> data) {
        this.data = data;
        fireTableDataChanged();
    }

    public SesijaPregled getAt(int row) { return data.get(row); }

    @Override public int getRowCount()    { return data.size(); }
    @Override public int getColumnCount() { return COLUMNS.length; }
    @Override public String getColumnName(int col) { return COLUMNS[col]; }

    @Override
    public Object getValueAt(int row, int col) {
        SesijaPregled s = data.get(row);
        return switch (col) {
            case 0 -> s.sesijaId();
            case 1 -> s.datum();
            case 2 -> s.pocetak();
            case 3 -> s.zavrsetak();
            case 4 -> s.statusSesije();
            case 5 -> s.eksperiment();
            case 6 -> s.laboratorija();
            case 7 -> s.statusIzvodjenja();
            default -> null;
        };
    }
}
