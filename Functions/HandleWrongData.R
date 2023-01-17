correctWrongCandidate = function(candidate)
{
  new_candidate = candidate
  if(substr(candidate,1,1) == "_")
  {
    new_candidate = substr(candidate, 2, nchar(candidate))
  }
  return (new_candidate)
}

correctWrongContent = function(content)
{
  new_content = content
  return (new_content)
}