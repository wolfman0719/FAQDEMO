import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export const RelatedTopics = (props: any) => {

  const {onClickItem, reftopics, linkBase} = props;
  const navigate = useNavigate();
  const comma: string = ",";
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);

  const getRowStyle = (index: number): React.CSSProperties => ({
    backgroundColor: hoveredIndex === index
      ? "#cce8f4"
      : index % 2 === 0 ? "#ffffff" : "#f5f5f5",
    cursor: "pointer",
  });

  return (
    <>
    <p className = "blue-text">関連トピック</p>
    <table style={{width: "100%"}}><tbody>

	  {
        reftopics.map((reftopic: any, index: number) => (
		  <tr key={index} style={getRowStyle(index)}
		      onMouseEnter={() => setHoveredIndex(index)}
		      onMouseLeave={() => setHoveredIndex(null)}>
		  <td style={{padding: "6px 8px", color: "#000000", whiteSpace: "nowrap"}}>{reftopic.split(comma)[0]}</td>
		  <td style={{padding: "6px 8px", width: "100%"}}><button style={{width: "100%", textAlign: "left", color: "#000000", background: "transparent", border: "none", padding: "0"}} onClick={() => linkBase ? navigate(`${linkBase}/${reftopic.split(comma)[0]}`) : onClickItem(reftopic.split(comma)[0])}>{reftopic.split(comma)[1]}</button></td>
		  </tr>
    	)
    )}
	</tbody></table>
    </>
  );
}
export default RelatedTopics;
