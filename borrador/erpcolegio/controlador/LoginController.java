/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.controlador;

import com.erpcolegio.dao.UsuarioDAO;
import com.erpcolegio.modelo.Usuario;
import com.erpcolegio.util.Encriptador;
import com.erpcolegio.util.SesionGlobal;

public class LoginController {
    public boolean procesarLogin(String username, String password) {
        if (username.isEmpty() || password.isEmpty()) {
            return false;
        }
        
        String hash = Encriptador.hashear(password);
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.autenticar(username, hash);
        
        if (usuario != null) {
            SesionGlobal.usuarioActual = usuario;
            return true;
        }
        
        return false;
    }
}
