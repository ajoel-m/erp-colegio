/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.util.validadores;

import javax.swing.JTextField;

public class InputValidator {
    // 1. Verifica si uno o más campos de texto están vacíos
    public static boolean estanVacios(JTextField... campos) {
        for (JTextField campo : campos) {
            if (campo.getText().trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    // 2. Verifica si el texto ingresado contiene únicamente números enteros
    public static boolean esNumeroEntero(String texto) {
        return texto.matches("\\d+");
    }

    // 3. Verifica si es un DNI válido ( 8 dígitos numéricos)
    public static boolean esDniValido(String dni) {
        return dni.matches("\\d{8}");
    }
    public static boolean esCeValido(String ce) {
        return ce.matches("^[a-zA-Z0-9]{9,12}$");
    }

    // 4. Verifica si es un número decimal válido (útil para notas o sueldos)
    public static boolean esDecimalValido(String texto) {
        return texto.matches("\\d+(\\.\\d+)?");
    }
    
    // 5. Verifica longitud máxima para no saturar la base de datos
    public static boolean excedeLongitud(String texto, int maximo) {
        return texto.trim().length() > maximo;
    }
    
    // 6. Verifica si es un número de celular peruano válido (9 dígitos, típicamente empieza con 9)
    public static boolean esTelefonoValido(String telefono) {
        return telefono.matches("9\\d{8}");
    }

    // 7. Verifica si tiene formato de correo electrónico básico
    public static boolean esCorreoValido(String correo) {
        return correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    }
}
