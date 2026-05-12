package rs.raf.farmakologija.model;

public record Laboratorija(
        int labId,
        String naziv,
        String zgrada,
        int sprat,
        String brProstorije
) {}
