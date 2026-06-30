import React from 'react';

export const Header = () => {
    
  return (
    <div style={{display: "flex", alignItems: "center", gap: "16px"}}>
      <a href="https://www.intersystems.com/jp" style={{outline: "none"}}><img src="https://www.intersystems.com/assets/intersystems-logo.png" alt="InterSystems Corporation" style={{width: "200", height: "50", border: "none", display: "block"}}/></a>
      <p className="blue-text" style={{margin: 0, fontSize: "2rem", fontWeight: 500}}> FAQ検索（よくあるご質問）</p>
    </div>
  );	
}
export default Header;
