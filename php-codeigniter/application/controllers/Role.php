<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Role extends CI_Controller {

	/**
	 * Index Page for this controller.
	 * Sample endpoint to check the role of a user
     * When any user makes a request to this endpoint with
     * the path containing the roleName. Eg: role/admin, role/user, role/anonymous
     * that path only gets served, if the user actually has that role.
     * To test, login to the console as an admin user. role/admin, role/user will work.
     * Make a request to role/admin, role/user from an incognito tab. They won't work, only role/anonymous will work.
	 */
	public function index($role)
	{
        $data['role'] = 'DENIED: Only a user with the role <b>' . $role .  '</b> can access this endpoint ';
        $allowedRoles = $this->input->get_request_header('X-Hasura-Allowed-Roles', TRUE);
        if( strpos( $allowedRoles, $role ) !== false )
        {
           $data['role'] = 'Hey, you have the <b>' . $role . '</b> role';  
        };
		$this->load->view('role_message', $data);
	}
}
