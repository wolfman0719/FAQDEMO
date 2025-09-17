import { useState } from "react";
import { useForm, SubmitHandler } from 'react-hook-form';
import { ErrorMessage } from '@hookform/error-message';
import { useNavigate } from "react-router-dom";
import axios from "axios";
import './Signin.css';
import configinfo from '../serverconfig.json';

//型宣言
type Inputs = {
    username: string;
    password: string;
}

export default function Signin() {
    const navigate = useNavigate();
    //errorMsg という名前のstate関数を宣言、初期値 null をセット
    const [errorMsg, setErrorMsg] = useState("");
    const [isLoading, setIsLoading] = useState(false);
    const [isError, setIsError] = useState(false);

    const ServerAddress = configinfo.ServerAddress;
    const ServerPort = configinfo.ServerPort;
    const ApplicationName = configinfo.ApplicationName;
    const Protocol = configinfo.Protocol;
        
    const {
        register,
        handleSubmit,
        reset,
        formState: { errors }
    } = useForm<Inputs>({
        mode: 'onChange',
    });

    //ログインボタンを押した際の処理
    const onSubmit: SubmitHandler<Inputs> = (data) =>{
        setIsLoading(true);
        setIsError(false);
        
        axios
          .get<any>(`${Protocol}://${ServerAddress}:${ServerPort}${ApplicationName}/Login/${data.username}/${data.password}`)
          .then((result: any) => {
            if (result.data.login === 1 || result.data.login === '1') {
                const params = {username: data.username, password: data.password, edit: result.data.edit}
                loginSuccess(params);
            }
            else {
                loginErrorMsg();
            }
          })
          .catch((error: any) => {
             setIsError(true)
          })
          .finally(() => setIsLoading(false))
          
        reset();
    };
    
    //ログインに成功した場合、次のページへ遷移
    const loginSuccess = (params: any) => {
      localStorage.clear();
      localStorage.setItem('username',params.username);
      localStorage.setItem('password',params.password);
      localStorage.setItem('edit',params.edit);

      navigate("/Home", { state: {username: params.username, password: params.password, edit: params.edit}});
    }

    //ログインに失敗した場合のエラーメッセージをセット
    const loginErrorMsg = () => {
        //setErrorMsg()でerrorMsgの値を更新
        setErrorMsg("ユーザーIDもしくはパスワードが間違っているか編集権限がありません");
    }
    
    //入力内容をクリア
    const clearForm = () => {
        reset();
    }

    return (
        <div className="formContainer">
        {isLoading && <p>Laoding...</p>}
        {isError && <p className="text-danger fs-3"><span dangerouslySetInnerHTML={{__html: errorMsg}}></span></p>}
        <form onSubmit={handleSubmit(onSubmit)}>
            <h1>ログイン</h1>
            <hr />
            <div className='uiForm'>
            <p className="errorMsg">{errorMsg}</p>
                <div className='formField'>
                    <label htmlFor="userID">ユーザーID</label>
                    <input 
                        id = "userID"
                        type="text"
                        autoComplete="userID" 
                        placeholder='userID' 
                        {...register('username', { 
                            required: 'ユーザーIDを入力してください。', 
                            maxLength: {
                                value: 20,
                                message: '20文字以内で入力してください。'
                            },
                            pattern: {
                                value:
                                    /^[A-Za-z0-9-_]+$/i,
                            message: 'ユーザーIDの形式が不正です。',
                            }, 
                        })}
                    />
                </div>
                <ErrorMessage errors={errors} name="username" render={({message}) => <span>{message}</span>} />
                <div className='formField'>
                    <label htmlFor="password">パスワード</label>
                    <input 
                        id = "password"
                        type="password"
                        autoComplete="current-password" 
                        placeholder='password' 
                        // eslint-disable-next-line
                        role = 'password'
                        {...register('password', { 
                            required: 'パスワードを入力してください。', 
                            maxLength: {
                                value: 20,
                                message: '20文字以内で入力してください',
                            },
                            pattern: {
                                value:
                                    /^[A-Za-z0-9#$%&-_]+$/i,
                            message: 'パスワードの形式が不正です。',
                            }, 
                        })} 
                    />
                </div>
                <ErrorMessage errors={errors} name="password" render={({message}) => <span>{message}</span>} />
                <div className="loginButton">
                    <button 
                        type = "submit"
                        className="submitButton"
                        >ログイン
                    </button>
                    <button 
                        type = "button"
                        className="clearButton" 
                        onClick={clearForm}
                        >クリア
                    </button>
                </div>
            </div>
        </form>
        </div>
  );
}