<!DOCTYPE html>
<html>
<head>
    <title>Test Advanced Fix</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>Test Advanced Fix untuk Customer: {{ $customer->name }}</h1>
    
    <button onclick="testAnalyzeAndFix()" class="btn btn-primary">
        Test Analisis & Perbaiki Data
    </button>
    
    <button onclick="testDebugSync()" class="btn btn-info">
        Test Debug Data Sync
    </button>

    <script>
        // Set up CSRF token
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        function testAnalyzeAndFix() {
            if (!confirm('Test analyze and fix data?')) {
                return;
            }

            $.ajax({
                url: '{{ route("data-sync.fob.analyze-and-fix", $customer->id) }}',
                method: 'POST',
                success: function(response) {
                    alert('Success: ' + JSON.stringify(response, null, 2));
                },
                error: function(xhr) {
                    alert('Error: ' + xhr.responseText);
                }
            });
        }

        function testDebugSync() {
            $.ajax({
                url: '{{ route("data-sync.fob.debug", $customer->id) }}',
                method: 'GET',
                success: function(response) {
                    alert('Debug Data: ' + JSON.stringify(response, null, 2));
                },
                error: function(xhr) {
                    alert('Error: ' + xhr.responseText);
                }
            });
        }
    </script>
</body>
</html>
