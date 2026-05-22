package rs.raf.farmakologija.model;

public record Biosafety(int biosafetyId, String naziv) {
    @Override
    public String toString() { return naziv; }
}