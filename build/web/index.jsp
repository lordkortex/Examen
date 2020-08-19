<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

    </head>
    <script>
        function validar_fechas(campo){           
            var fecha= document.getElementById(campo).value;         
            var exr= /^(0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])[\/\-]\d{4}$/;         
            if (!exr.test(fecha)){
                alert("Ingrese una fecha valida, MM/DD/YYYY");
                document.getElementById(campo).value="";
                return false;
            }
            return true;                
        }
        
        function recargarSelect(){
            document.getElementById("id_f1").submit();
        }
        
        function evaluarMoverse(){
            if(validar_fechas('id_finicio') &&
                validar_fechas('id_ffin')  
        ){
                document.getElementById("id_f1").action="index.jsp?bt=1";               
                document.getElementById("id_f1").submit();
            }  
            else{
                alert("los datos ingresados no son correctos");
            }
        }


        function detalleRecarga(url){
            window.open(url, "Detalle Recarga", "menubar=0, resizable=0, width=200, height=200");
        }  
    </script>

    <body>        
        <form name="f1" action="index.jsp" method="POST" id="id_f1">            
            ZONA <select name="cb_zona" 
                         id="id_zona" onchange="recargarSelect();">
                <option>TODAS</option>
                <%
                    try {
                        Dba db = new Dba(application.getRealPath("")+"jsbasico.mdb");
                        db.conectar();
                        db.query.execute("select zona from recargas group by zona");
                        ResultSet rs = db.query.getResultSet();
                        if (!rs.next()) {
                            out.println("<option>No hay datos</option>");
                        } else {
                            do {
                                String v_zona = rs.getString(1);
                                if (request.getParameter("cb_zona") == null) { //primera vez que entramos
                                    out.println("<option>" + v_zona + "</option>");
                                } else {
                                    if (v_zona.equals(request.getParameter("cb_zona"))) {
                                        out.println("<option selected>" + v_zona + "</option>");
                                    } else {
                                        out.println("<option>" + v_zona + "</option>");
                                    }
                                }
                            } while (rs.next());
                        }
                        db.desconectar();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>
            <br>

            TEAM
            <select name="cb_team" id="id_team">
                <option>TODOS</option>
                <%
                    try {
                        Dba db = new Dba(application.getRealPath("")+"jsbasico.mdb");
                        db.conectar();
                        if (request.getParameter("cb_zona") == null || request.getParameter("cb_zona").equals("TODAS")) { //primera vez que entramos
                            db.query.execute("select team from recargas group by team");
                        } else {
                            db.query.execute("select team from recargas where zona='" + request.getParameter("cb_zona") + "' group by team");
                        }
                        ResultSet rs = db.query.getResultSet();
                        if (!rs.next()) {
                            out.println("<option>No hay datos</option>");
                        } else {
                            do {
                                out.println("<option>" + rs.getString(1) + "</option>");
                            } while (rs.next());
                        }

                        db.desconectar();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </select>
            <br>
            Fecha Inicio:
            <input type="text" name="ti_finicio" id="id_finicio" value="" onblur="validar_fechas('id_finicio')" />
            <br>
            Fecha Fin:
            <input type="text" name="ti_ffin" id="id_ffin" value="" onblur="validar_fechas('id_ffin')"/>
            <br>
            <br>             
        </form>
        <input type="button"  value="Generar Reporte" 
               onclick="evaluarMoverse();"
               name="bt_evaluar" />             
        <br>
        <hr>
        
        

        <%
            //generar reporte si hizo click al boton generar
            if (request.getParameter("bt") != null) {
                try {
                    Dba db = new Dba(application.getRealPath("")+"jsbasico.mdb");
                    db.conectar();

                    if (request.getParameter("cb_zona").equals("TODAS")) {
                        if (request.getParameter("cb_team").equals("TODOS")) {
                            db.query.execute("select msisdn, team, zona from recargas where fecha between #"+request.getParameter("ti_finicio")+"# and #"+request.getParameter("ti_ffin")+"# ");
                        } else {
                            db.query.execute("select msisdn, team, zona from recargas where team='" + request.getParameter("cb_team") + "' and fecha between #"+request.getParameter("ti_finicio")+"# and #"+request.getParameter("ti_ffin")+"#   ");
                        }
                    } else {
                        if (request.getParameter("cb_team").equals("TODOS")) {
                              db.query.execute("select msisdn, team, zona from recargas where zona='" + request.getParameter("cb_zona") + "' and fecha between #"+request.getParameter("ti_finicio")+"# and #"+request.getParameter("ti_ffin")+"# ");
                         } else {
                               db.query.execute("select msisdn, team, zona from recargas where zona='" + request.getParameter("cb_zona") + "' and team='" + request.getParameter("cb_team") + "' and fecha between #"+request.getParameter("ti_finicio")+"# and #"+request.getParameter("ti_ffin")+"#   ");
                         }                       
                    }


                    ResultSet rs = db.query.getResultSet();
                    while (rs.next()) {
                        String c1,c2,c3;
                        c1=rs.getString(1);
                        c2=rs.getString(2);
                        c3=rs.getString(3);
                        out.print(c1 + " ---> " + c2+ " ---> " + c3 + " ---> ");
                        
                        String url="detalle.jsp?tel="+c1+" ";
                        String link="javascript:detalleRecarga('"+url+"');";
                        out.print("<a href=\""+link+"\">ver detalle</a> " +"<br>");
                    }
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        %>    


    </body>
</html>
