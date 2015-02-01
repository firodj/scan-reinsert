c:\php5\php.exe %0
pause > nul
exit
<?php
echo "Type the subdir (not contains output):\n";
$line = stream_get_line(STDIN, 1024, PHP_EOL);

$subdir = trim($line);
if (empty($subdir) || strpos(strtolower($subdir), 'output') !== FALSE) {
  die("I dont understand what you mean?\n");	
}

$files = glob("{$subdir}/*.jpg");
if (empty($files)) {
  die("Nothing to do!\n");
}

sort($files, SORT_NATURAL);
foreach ($files as $i=>$file) {
  echo "{$i} {$file}\n";
}
echo "Start from First or Last? [F/L]:\n";
$line = stream_get_line(STDIN, 1024, PHP_EOL);

$f = NULL;
if (strtolower($line) == 'l') {
  echo "you choose last\n";
  $f = false;
} else if (strtolower($line) == 'f') {
  echo "you choose first\n";
  $f = true;
} else {
  echo "You stupid moron!\n";
}

$result = [];
if (!is_null($f)) {
  for($i = 0, $j = count($files) - 1; 
      $i < $j;
      ++$i, --$j) {
     
      if ($f) {
        $result[] = $files[$i];
        $result[] = $files[$j];
      } else {
        $result[] = $files[$j];
        $result[] = $files[$i];
      }
  }  
  if ($i == $j) $result[] = $files[$i];
}

foreach ($result as $i=>$file) {
  $output = sprintf("output/{$subdir}-%04d.jpg", $i);
  echo "{$i} {$file} -> {$output}\n";
  copy($file, $output);
}
