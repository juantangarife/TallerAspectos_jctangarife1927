package uniandes.cupi2.impuestosCarro.jc_tangarife1927.aspects;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;

import uniandes.cupi2.impuestosCarro.mundo.CalculadorImpuestos;
import uniandes.cupi2.impuestosCarro.mundo.Vehiculo;

public aspect AddCar {
	private static final String ASPECT_VEHICLES= "data_aspect_addcars/vehiculos.txt";
	
	pointcut addCar():
		//execution(CalculadorImpuestos.new());
		execution(private void cargarVehiculos(String) throws Exception);
	
	void around() throws Exception: addCar(){
		Object that = thisJoinPoint.getThis();
		Object[] args = thisJoinPoint.getArgs();
		String pArchivo = (String) args[0];
		Field vehiculosField = that.getClass().getDeclaredField("vehiculos");
		Field posVehiculoActualField = that.getClass().getDeclaredField("posVehiculoActual");
		vehiculosField.setAccessible(true);
		posVehiculoActualField.setAccessible(true);
		
		String texto, textoAspect, valores[], valoresAspect[], sMarca, sLinea, sModelo, sImagen;
        double precio;
        int cantidad = 0;
        int cantidadAspect = 0;
        Vehiculo vehiculo;
        Vehiculo[] vehiculos;
        try
        {
            File datos = new File( pArchivo );
            FileReader fr = new FileReader( datos );
            BufferedReader lector = new BufferedReader( fr );
            texto = lector.readLine();
            cantidad = Integer.parseInt( texto );
            
            File datosAspect = new File( ASPECT_VEHICLES );
            FileReader frAspect = new FileReader( datosAspect );
            BufferedReader lectorAspect = new BufferedReader( frAspect );
            textoAspect = lectorAspect.readLine( );
            cantidadAspect = Integer.parseInt( textoAspect );
            
            vehiculos = new Vehiculo[cantidad + cantidadAspect];
            posVehiculoActualField.set(that, 0);
            

            texto = lector.readLine( );
            for( int i = 0; i < cantidad; i++ )
            {
                valores = texto.split( "," );

                sMarca = valores[ 0 ];
                sLinea = valores[ 1 ];
                sModelo = valores[ 2 ];
                sImagen = valores[ 4 ];
                precio = Double.parseDouble( valores[ 3 ] );

                vehiculo = new Vehiculo( sMarca, sLinea, sModelo, precio, sImagen );
                vehiculos[ i ] = vehiculo;
                // Siguiente línea
                texto = lector.readLine( );
            }
            
            textoAspect = lectorAspect.readLine( );
            for( int i = cantidad; i < cantidad + cantidadAspect; i++ )
            {
                valoresAspect = textoAspect.split( "," );
                sMarca = valoresAspect[ 0 ];
                sLinea = valoresAspect[ 1 ];
                sModelo = valoresAspect[ 2 ];
                sImagen = valoresAspect[ 4 ];
                precio = Double.parseDouble( valoresAspect[ 3 ] );

                vehiculo = new Vehiculo( sMarca, sLinea, sModelo, precio, sImagen );
                vehiculos[ i ] = vehiculo;
                // Siguiente línea
                textoAspect = lectorAspect.readLine( );
            }
            
            vehiculosField.set(that, vehiculos);
            
            lector.close( );
            lectorAspect.close();
            
            vehiculosField.setAccessible(false);
    		posVehiculoActualField.setAccessible(false);
        }
        catch( IOException e )
        {
            throw new Exception( "Error al cargar los datos almacenados de vehículos." );
        }
        catch( NumberFormatException e )
        {
            throw new Exception( "El archivo no tiene el formato esperado." );
        }
        catch (IllegalArgumentException e) {
			e.printStackTrace();
		}
        catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}
}
