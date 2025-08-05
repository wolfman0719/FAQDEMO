import { useEffect,useState } from "react";
import { useForm, SubmitHandler } from 'react-hook-form';
import { ErrorMessage } from '@hookform/error-message';
import { useNavigate } from "react-router-dom";
import axios from "axios";
import configinfo from '../serverconfig.json';

export default function NoSignin() {

const navigate = useNavigate();
    
useEffect( () => {
  localStorage.clear();
  localStorage.setItem('username','_system');
  localStorage.setItem('password','SYS');
  localStorage.setItem('edit','0');
  navigate("/Home",  { state: {username: '_system', password: 'SYS', edit: 0}});
}, []);   

return (
<></>
  );
}