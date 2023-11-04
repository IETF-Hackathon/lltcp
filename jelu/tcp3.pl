while (<>) {
    chomp;
    @a = split(/\s+/go);
    if ($a[10] > 100) {
        print($_, "\n");
    }
}
