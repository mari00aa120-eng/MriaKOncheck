package edu.konrad.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.logging.Logger;

public class JwtUtil {
    
    private static final Logger LOGGER = Logger.getLogger(JwtUtil.class.getName());
    
    private static final String SECRET_KEY = getSecretKey();
    private static final Key KEY = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    
    // Tiempo de expiración: 24 horas
    private static final long EXPIRATION_TIME = 86400000; // 24 horas en milisegundos
    
    private static String getSecretKey() {
        String envKey = System.getenv("JWT_SECRET_KEY");
        
        if (envKey != null && !envKey.isEmpty()) {
            if (envKey.length() < 32) {
                LOGGER.warning("JWT_SECRET_KEY es demasiado corta. Debe tener al menos 32 caracteres.");
                throw new IllegalStateException("JWT_SECRET_KEY debe tener al menos 32 caracteres");
            }
            LOGGER.info("Usando JWT_SECRET_KEY desde variable de entorno");
            return envKey;
        }
        
        // Clave por defecto solo para desarrollo
        LOGGER.warning("ADVERTENCIA: Usando clave JWT por defecto. Configure JWT_SECRET_KEY en producción.");
        return "KonCheck2025SecretKeyForJWTTokenGenerationMustBe256BitsLongForSecurity";
    }
    
    public static String generateToken(Long userId, String correo) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME);
        
        return Jwts.builder()
                .setSubject(userId.toString())
                .claim("correo", correo)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(KEY, SignatureAlgorithm.HS256)
                .compact();
    }
    
    public static Claims validateToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
    
    public static Long getUserIdFromToken(String token) {
        Claims claims = validateToken(token);
        return Long.parseLong(claims.getSubject());
    }
    
    public static String getCorreoFromToken(String token) {
        Claims claims = validateToken(token);
        return claims.get("correo", String.class);
    }
    
    public static boolean isTokenExpired(String token) {
        try {
            Claims claims = validateToken(token);
            return claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }
}
