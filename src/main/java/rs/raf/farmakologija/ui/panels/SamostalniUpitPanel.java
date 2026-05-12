package rs.raf.farmakologija.ui.panels;

import javax.swing.*;
import java.awt.*;

public class SamostalniUpitPanel extends JPanel {

    public SamostalniUpitPanel() {
        setLayout(new BorderLayout());
        JLabel placeholder = new JLabel(
                "<html><div style='padding:30px;color:#666;text-align:center'>"
                        + "<b>TODO: Implementacija samostalnog upita.</b><br><br>"
                        + "Kada izabereš upit, ovde ide forma koja ga izvršava i prikazuje rezultate."
                        + "</div></html>");
        placeholder.setHorizontalAlignment(SwingConstants.CENTER);
        add(placeholder, BorderLayout.CENTER);
    }
}
