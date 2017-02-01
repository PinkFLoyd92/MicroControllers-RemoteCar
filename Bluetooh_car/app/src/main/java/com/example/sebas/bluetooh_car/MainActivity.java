package com.example.sebas.bluetooh_car;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigInteger;
import java.util.Set;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {
    // constant passed to startActivityForResult() is a locally defined integer (which must be greater than 0)
    private static final int REQUEST_ENABLE_BT = 1;
    //class to communicate with Bluetooth
    //private Set<BluetoothDevice> pairedDevices;
    Spinner combo_item;
    BluetoothDevice device;
    ConnectThread conexion;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
        this.combo_item = (Spinner) findViewById(R.id.combo_item);
        Resources res = getResources();
        String[] planets = res.getStringArray(R.array.planets_array);
        ArrayAdapter adapter = ArrayAdapter.createFromResource(
                this, R.array.planets_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        combo_item.setAdapter(adapter);

    }
    public void click_conectar(View view) {
        Button button_conectar = null;
        Set<BluetoothDevice> pairedDevices = null;
        Set<String> mArrayAdapter = null;
        TextView texto_device = null;
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter == null) {
            // no soporta bluetooh
            Log.i("mensaje", "no soporta bluetooh");
            Toast.makeText(this.getApplicationContext(),"No soporta bluetooh",Toast.LENGTH_LONG).show();
        }
        if (!mBluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
        try {
            pairedDevices = mBluetoothAdapter.getBondedDevices();
        } catch(Exception e){
            Toast.makeText(this.getApplicationContext(),"No se puede leer dispositivo",Toast.LENGTH_LONG).show();
        }
// If there are paired devices
        try {
            if (pairedDevices.size() > 0) {
                // Loop through paired devices
                // Add the name and address to an array adapter to show in a ListView
                for (BluetoothDevice device : pairedDevices) {
                    Log.i("ondina", device.getName()+ '\n' + device.getName());

                    //if(device.getAddress() == "20:15:11:09:93:57" || device.getName()=="HC-06") {
                        this.device = device;
                        Toast.makeText(this.getApplicationContext(), "Detectado" + device.getName(), Toast.LENGTH_LONG).show();
                    //}else
                      //  Toast.makeText(this.getApplicationContext(), "No hay dispositivo conectado",Toast.LENGTH_SHORT).show();

                }
                // mArrayAdapter.add(device.getName() + "\n" + device.getAddress());
            }
        }catch(Exception e)
        {
            Toast.makeText(this.getApplicationContext(),"No hay dispositivos pareados con el telefono",Toast.LENGTH_LONG).show();
        }
        /**
         * Socket management
         */
        try {
            this.conexion = new ConnectThread(this.device); //establecer conexion al servidor--> carrito.
            this.conexion.run();
            Log.i("conexion", conexion.getName());

            button_conectar = (Button)findViewById(R.id.conectar); // se desactiva el widget suponiendo que se la realizo con exito.
            texto_device = (TextView)findViewById(R.id.texto_password);
            button_conectar.setClickable(false);
            button_conectar.setBackgroundColor(Color.BLUE);
            button_conectar.setText("Conectado al modulo.");
            texto_device.setText(this.device.getName()+ ' '+this.device.getAddress()+'\n'+this.conexion.getName());
            texto_device.setBackgroundColor(Color.GREEN);

           // Toast.makeText(getApplicationContext(),this.device.getName()+' '+this.device.getAddress(),Toast.LENGTH_LONG);

        }catch (Exception e){
            Toast.makeText(this.getApplicationContext(),"No se puede iniciar la conexion con el modulo.",Toast.LENGTH_LONG).show();
        }
    }
    public void click_adelante(View view) {
        Button b = (Button) view;
        try {
            Log.i("test",b.getText().toString());
            switch (b.getText().toString()) {

                case "ADELANTE":
                    //this.conexion.write("u".getBytes());
                    this.conexion.write('u');
                    Toast.makeText(getApplicationContext(),"ADELANTE",Toast.LENGTH_SHORT).show();
                    break;
                case "ATRAS":
                    this.conexion.write('d');
                    //this.conexion.write("d".getBytes());
                    Toast.makeText(getApplicationContext(),"ATRAS",Toast.LENGTH_SHORT).show();
                    break;

                case "DERECHA":
                    //this.conexion.write("r".getBytes());
                    this.conexion.write('r');
                    Toast.makeText(getApplicationContext(),"DERECHA",Toast.LENGTH_SHORT).show();
                    break;
                case "IZQUIERDA":
                    //this.conexion.write("l".getBytes());
                    this.conexion.write('l');
                    Toast.makeText(getApplicationContext(),"IZQUIERDA",Toast.LENGTH_SHORT).show();
                    break;
                case "SALIR":
                    //this.conexion.write("e".getBytes());
                    this.conexion.write('e');
                    Toast.makeText(getApplicationContext(),"SALIR",Toast.LENGTH_SHORT).show();
                    break;
                case "MANUAL":
                    //this.conexion.write("M".getBytes());
                    this.conexion.write('M');
                    Toast.makeText(getApplicationContext(),"MODO MANUAL",Toast.LENGTH_SHORT).show();
                    break;
                case "AUTOMATICO":
                    //this.conexion.write("A".getBytes());
                    this.conexion.write('A');
                    Toast.makeText(getApplicationContext(),"MODO AUTOMATICO",Toast.LENGTH_SHORT).show();
                    break;
                default:
                    break;
            }
        }catch(Exception e){
            //Log.i("ondina",);
        }
    }






    private class ConnectThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final BluetoothDevice mmDevice;
        public UUID id;
        public OutputStream output;
        public ConnectThread(BluetoothDevice device) {
            // Use a temporary object that is later assigned to mmSocket,
            // because mmSocket is final
            BluetoothSocket tmp = null;
            mmDevice = device;

            // Get a BluetoothSocket to connect with the given BluetoothDevice
            try {
                // MY_UUID is the app's UUID string, also used by the server code
                UUID uuid =
                        UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
                this.id =uuid;//id del cliente.
                tmp = device.createRfcommSocketToServiceRecord(id); // usada tb por el server.
            } catch (IOException e) {
                Log.i("fail","fail");}
            mmSocket = tmp;
        }

        public void run() {
            // Cancel discovery because it will slow down the connection
            //mBluetoothAdapter.cancelDiscovery();

            try {
                // Connect the device through the socket. This will block
                // until it succeeds or throws an exception
                mmSocket.connect();
            } catch (IOException connectException) {
                // Unable to connect; close the socket and get out
                try {
                    mmSocket.close();
                } catch (IOException closeException) { }
                return;
            }

            // Do work to manage the connection (in a separate thread)
            manageConnectedSocket(mmSocket);
        }
        public void manageConnectedSocket(BluetoothSocket socket){
            OutputStream salida = null;
            try {
                salida = socket.getOutputStream();
            } catch (IOException e) { }

            this.output = salida;
        }

        /** Will cancel an in-progress connection, and close the socket */
        public void cancel() {
            try {
                this.mmSocket.close();
            } catch (IOException e) { }
        }
        public void write(Character c) {
            Log.i("mensaje","Intentando enviar");
            try {
                this.output.write(c);
            }catch (Exception e){
                Toast.makeText(getApplicationContext(),"No se pudo enviar mensaje, revisar stream de salida.",Toast.LENGTH_LONG);
            }
            Log.i("mensaje","enviado");
        }
    }
}


