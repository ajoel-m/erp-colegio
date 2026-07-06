/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.util;

import com.erpcolegio.modelo.Usuario;

public class SesionGlobal {
    public static Usuario usuarioActual = null;
    
    public static void limpiarSesion() {
        usuarioActual = null;
    }
}
