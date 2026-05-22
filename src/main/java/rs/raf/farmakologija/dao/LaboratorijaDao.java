package rs.raf.farmakologija.dao;

import rs.raf.farmakologija.db.DatabaseConnection;
import rs.raf.farmakologija.model.Biosafety;
import rs.raf.farmakologija.model.Laboratorija;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LaboratorijaDao {

    public List<Laboratorija> findAll() throws SQLException {
        String sql = "SELECT lab_id, naziv, zgrada, sprat, br_prostorije FROM laboratorija ORDER BY naziv";
        try (Connection c = DatabaseConnection.get();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            List<Laboratorija> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new Laboratorija(
                        rs.getInt("lab_id"),
                        rs.getString("naziv"),
                        rs.getString("zgrada"),
                        rs.getInt("sprat"),
                        rs.getString("br_prostorije")
                ));
            }
            return result;
        }
    }

    public List<Biosafety> findAllBiosafety() throws SQLException {
        String sql = "SELECT biosafety_id, naziv FROM biosafety_nivo ORDER BY nivo";
        try (Connection c = DatabaseConnection.get();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            List<Biosafety> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new Biosafety(
                        rs.getInt("biosafety_id"),
                        rs.getString("naziv")
                ));
            }
            return result;
        }
    }

    public String dodaj(String naziv, String zgrada, int sprat,
                        String brProstorije, int biosafetyId) throws SQLException {
        String sql = "CALL dodaj_laboratoriju(?, ?, ?, ?, ?)";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, naziv);
            ps.setString(2, zgrada);
            ps.setInt(3, sprat);
            ps.setString(4, brProstorije);
            ps.setInt(5, biosafetyId);
            ps.execute();
            try (ResultSet rs = ps.getResultSet()) {
                if (rs != null && rs.next()) return rs.getString("poruka");
            }
            return "OK";
        }
    }

    public String delete(int labId) throws SQLException {
        String sql = "CALL obrisi_laboratoriju(?)";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, labId);
            ps.execute();
            try (ResultSet rs = ps.getResultSet()) {
                if (rs != null && rs.next()) return rs.getString("poruka");
            }
            return "OK";
        }
    }
}