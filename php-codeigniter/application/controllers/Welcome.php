<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Welcome extends CI_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see https://codeigniter.com/user_guide/general/urls.html
	 */
	public function index()
	{
        $curl = curl_init(DATA_URL . '/v1/query');
        $json = json_encode(
            array(
                'type' => 'select',
                'args' => array(
                    'table' => array(
                        'schema' => 'hdb_catalog',
                        'name' => 'hdb_table'
                    ),
                    'columns' => array('*.*'),
                    'where' => array(
                        'table_schema' => 'public'
                    )   
                )
            ) 
        );
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");        
        curl_setopt($curl, CURLOPT_HTTPHEADER, DATA_HEADERS);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $json);
        $result = curl_exec($curl);
        $data['result'] = json_decode($result, true);
        $data['code'] = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        curl_close($curl);
		$this->load->view('welcome_message', $data);
	}
}
