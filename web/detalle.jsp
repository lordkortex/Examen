<%@page import="java.sql.ResultSet"%>
<%@page import="database.Dba"%>
Telefono:<%= request.getParameter("tel")+"<br><br>" %>

<%

 try {
                    Dba db = new Dba(application.getRealPath("")+"jsbasico.mdb");
                    db.conectar();
                    db.query.execute("select team, zona, fecha, monto from recargas where msisdn='"+request.getParameter("tel")+"' ");
                    ResultSet rs = db.query.getResultSet();
                    rs.next();
                    out.print("Team:"+rs.getString(1)+"<br><br>");
                    out.print("Zona:"+rs.getString(2)+"<br><br>");
                    out.print("Fecha:"+rs.getDate(3).toString()+"<br><br>");
                    out.print("Monto:"+rs.getDouble(4) +"<br><br>");
                    
                    db.desconectar();
                } catch (Exception e) {
                    e.printStackTrace();
                }
%>