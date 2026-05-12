package rs.raf.farmakologija.dao;

import rs.raf.farmakologija.db.DatabaseConnection;

import java.sql.*;

public class IstrazivacDao {

    public int countByLab(int labId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM istrazivac WHERE lab_id = ?";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, labId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
}
